import 'package:converter_plus_plus/components/custom-card.dart';
import 'package:converter_plus_plus/enums/media-quality.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/enums/replace-file.dart';
import 'package:converter_plus_plus/exceptions/validate-exception.dart';
import 'package:converter_plus_plus/helpers/ffmpeg.dart';
import 'package:converter_plus_plus/helpers/validate.dart';
import 'package:converter_plus_plus/helpers/loading-dialog.dart';
import 'package:converter_plus_plus/models/list-files-store.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Vars
  late FFprobe _ffprobe;
  late FFmpeg _ffmpeg;
  bool _convertAll = true;
  bool _useSameSettings = false;
  final _boxDecoration = BoxDecoration(
    border: Border.all(color: AppTheme.colorScheme.primary, width: 1),
    borderRadius: BorderRadius.circular(10),
  );

  // Lists
  final ListFilesStore _listFiles = ListFilesStore();
  List<String> _conversionFormats = [];

  // Controllers
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _extController = TextEditingController();
  final _pathController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _loadFiles,
        backgroundColor: AppTheme.colorScheme.primary,
        child: const Icon(Icons.note_add_rounded),
      ),

      body: Row(
        children: [
          // Lista
          Expanded(
            child: Observer(
              builder: (_) {
                return _listFiles.files.isNotEmpty
                ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: _listFiles.files.length,
                  itemBuilder: (_, index) => Observer(
                    builder: (_) => ListTile(
                      selectedTileColor: AppTheme.colorScheme.primary.withOpacity(.25),
                      selected: index == _listFiles.selectedIndex,
                      tileColor: index%2 == 1 ? AppTheme.colorScheme.secondary : null,
                      leading: Icon(_listFiles.files[index].type.icon),
                      trailing: Checkbox(
                        checkColor: Colors.black,
                        value: _listFiles.files[index].output.checked,
                        onChanged: (value){
                          _listFiles.files[index].output.setChecked(value!);
                        },
                      ),
                      title: Text(_listFiles.files[index].fullName),
                      onTap: () {
                        _listFiles.setSelectedIndex(index);
                      },
                    ),
                  ),
                )
                : _emptyList();
              },
            ),
          ),

          const VerticalDivider(width: 2, color: Colors.white),

          // Formulário
          Expanded(
            child: Observer(
              builder: (context) {
                if(_listFiles.files.isNotEmpty) {
                  _widthController.text = _listFiles.selected.output.size.width.toString();
                  _heightController.text = _listFiles.selected.output.size.height.toString();
                  _extController.text = _listFiles.selected.output.format.extension;
                  _pathController.text = _listFiles.selected.output.path;
                  _subtitleController.text = _listFiles.selected.output.subtitles;
                  _nomeController.text = _listFiles.selected.output.name;
                  _conversionFormats = _listFiles.selected.getConversionFormats();

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    children: [
                      CustomCard(title: 'Saída', children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _pathController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.folderOpen, size: 20),
                                  labelText: 'Pasta de saída',
                                ),
                                onChanged: (value) => _listFiles.selected.output.path = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final result = await FilePicker.platform.getDirectoryPath();
                                _listFiles.selected.output.path = result ?? '';
                                _pathController.text = _listFiles.selected.output.path;
                              },
                              icon: const Icon(FontAwesomeIcons.solidFolder, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nomeController,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'([/|<>:*"?\u005C])+'))],
                          onChanged: (value) => _listFiles.selected.output.name = value,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.fileSignature, size: 20),
                            labelText: 'Nome do arquivo de saída',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField(
                          onChanged: (value) => _listFiles.selected.output.replaceFile = value!,
                          isExpanded: true,
                          value: _listFiles.selected.output.replaceFile,
                          items: ReplaceFile.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.descricao),
                            );
                          }).toList(),
                        ),
                      ]),

                      CustomCard(title: 'Formato', children: [
                        Row(
                          children: [
                            Expanded(
                              child: Observer(
                                builder: (_) => DropdownButtonFormField(
                                  onChanged: (value) {
                                    if(value != _listFiles.selected.output.type) {
                                      _listFiles.selected.output.setType(value!);
                                      _conversionFormats = _listFiles.selected.getConversionFormats();
                                      final format = _conversionFormats.first;

                                      if(format == 'Manter') {
                                        _listFiles.selected.output.setFormat(format, _listFiles.selected.extension);
                                        _extController.text = _listFiles.selected.extension;
                                      } else {
                                        _listFiles.selected.output.setFormat(format, format);
                                        _extController.text = format;
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(),
                                  isExpanded: true,
                                  value: _listFiles.selected.output.type,
                                  items: _listFiles.selected.getConversionTypes().map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e.descricao),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Observer(
                                builder: (_) => DropdownButtonFormField(
                                  onChanged: (value) {
                                    if(value == 'Manter') {
                                      _listFiles.selected.output.setFormat(value!, _listFiles.selected.extension);
                                      _extController.text = _listFiles.selected.extension;
                                    } else if(value == 'Customizado') {
                                      _listFiles.selected.output.setFormat(value!, '');
                                      _extController.text = '';
                                    } else {
                                      _listFiles.selected.output.setFormat(value!, value);
                                      _extController.text = value;
                                    }
                                  },
                                  decoration: const InputDecoration(),
                                  hint: Text(
                                    'Formato',
                                    style: TextStyle(color: AppTheme.colorScheme.primary),
                                  ),
                                  isExpanded: true,
                                  value: _listFiles.selected.output.format.key,
                                  items: _conversionFormats.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Observer(
                              builder: (_) => TextFormField(
                                controller: _extController,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([A-Za-z0-9])+'))],
                                readOnly: !('Customizado'.contains(_listFiles.selected.output.format.key)),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.filePen, size: 20),
                                  labelText: 'Extenção',
                                ),
                              ),
                            )),
                          ],
                        ),
                      ]),

                      if(_listFiles.selected.output.type == MediaType.image || _listFiles.selected.output.type == MediaType.video)
                        CustomCard(title: 'Qualidade', children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Observer(
                                  builder: (_) => DropdownButtonFormField(
                                    onChanged: (value) {
                                      final int height;
                                      final int width;

                                      if(value!.descricao == 'Manter') {
                                        height = _listFiles.selected.height;
                                        width = _listFiles.selected.width;
                                      } else if(value.descricao == 'Customizado') {
                                        height = width = 0;
                                      } else {
                                        height = value.valor;
                                        width = (height*_listFiles.selected.aspectRatio).round();
                                      }

                                      _listFiles.selected.output.setSize(value, width, height);
                                      _widthController.text = width > 0 ? width.toString() : '';
                                      _heightController.text = height > 0 ? height.toString() : '';
                                    },
                                    hint: Text(
                                      'Selecione a qualidade',
                                      style: TextStyle(color: AppTheme.colorScheme.primary),
                                    ),
                                    isExpanded: true,
                                    value: _listFiles.selected.output.size.quality,
                                    items: MediaQuality.values.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e.descricao),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  textAlign: TextAlign.end,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  readOnly: _listFiles.selected.output.size.quality != MediaQuality.custom,
                                  controller: _widthController,
                                  decoration: const InputDecoration(labelText: 'Largura'),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.close_rounded),
                              ),
                              Expanded(
                                child: Observer(
                                  builder: (_) => TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    readOnly: _listFiles.selected.output.size.quality != MediaQuality.custom,
                                    controller: _heightController,
                                    decoration: const InputDecoration(labelText: 'Altura'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),

                      if(_listFiles.selected.output.type == MediaType.video) CustomCard(title: 'Legendas', children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _subtitleController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.closedCaptioning, size: 20),
                                  labelText: 'Arquivo de legenda',
                                ),
                                onChanged: (value) => _listFiles.selected.output.subtitles = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['srt', 'ass']);
                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  _listFiles.selected.output.subtitles = file.path ?? '';
                                } else {
                                  _listFiles.selected.output.subtitles = '';
                                }

                                _subtitleController.text = _listFiles.selected.output.subtitles;
                              },
                              icon: const Icon(FontAwesomeIcons.solidFolder, size: 20),
                            ),
                          ],
                        ),
                      ]),

                      CustomCard(title: 'Converter', children: [
                        Container(
                          decoration: _boxDecoration,
                          child: ListTile(
                            trailing: Switch(
                              value: _useSameSettings,
                              onChanged: (value) => setState(() => _useSameSettings = value),
                            ),
                            title: const Text('Usar essas configurações em todos os arquivos selecionados'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: _boxDecoration,
                          child: ListTile(
                            trailing: Switch(
                              value: _convertAll,
                              onChanged: (value) => setState(() => _convertAll = value),
                            ),
                            title: const Text('Converter todos os arquivos selecionados'),
                          ),
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _convert,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.auto_mode_rounded, size: 26),
                          ),
                          label: const Text('CONVERTER  ', style: TextStyle(fontSize: 20)),
                        ),
                      ]),
                    ],
                  );
                }

                return _emptyForm();
              }
            ),
          ),
        ],
      ),
    );
  }

  void _loadFiles() {
    showLoadingDialog(context, operation: () async {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if(result == null) {
        throw ValidateException(erros: {
          'Arquivo não identificado': ['Falha ao carregar arquivo. Verifique se o arquivo é uma mídia de vídeo, áudio ou imagem.']
        });
      }

      _ffprobe = FFprobe(result.files);
      _listFiles.addAll(await _ffprobe.getMediaFiles());

      _ffprobe.throwErrors();
    });
  }

  void _convert() {
    print('---------------------------------------------');
    print(_listFiles.selected.toString());
    print('---------------------------------------------');

    showLoadingDialog(context, operation: () async {
      if(_convertAll) {
        _ffmpeg = FFmpeg.fromList(_listFiles.files);
        if(_useSameSettings) {
          Validate.validateMediaFile(_listFiles.selected);
        } else {
          Validate.validateListMediaFile(_listFiles.files);
        }
      } else {
        _ffmpeg = FFmpeg(_listFiles.selected);
        Validate.validateMediaFile(_listFiles.selected);
      }

      _ffmpeg.prepareStatement(_useSameSettings ? _listFiles.selected.output : null);
      print('ffmpeg ${_convertAll ? _ffmpeg.argumentList.map((e) => e.join(' ')) : _ffmpeg.arguments.join(' ')}');
      print('__________________________________________________________________________________________________________________________');
    });
  }

  Widget _emptyForm() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.solidFileVideo, size: 200),
          const SizedBox(height: 24),
          Text(
            'Aqui aparecerão as configurações do arquivo selecionado na lista ao lado',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 32),
          ),
        ],
      ),
    );
  }

  Widget _emptyList() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.note_add_rounded, size: 240),
          const SizedBox(height: 24),
          Text(
            'Adicione arquivos clicando no botão abaixo',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.colorScheme.primary, fontSize: 32),
          ),
        ],
      ),
    );
  }
}