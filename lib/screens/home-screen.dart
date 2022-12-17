import 'dart:convert';
import 'dart:io';

import 'package:converter_plus_plus/components/custom-card.dart';
import 'package:converter_plus_plus/enums/media-quality.dart';
import 'package:converter_plus_plus/enums/media-type.dart';
import 'package:converter_plus_plus/enums/replace-file.dart';
import 'package:converter_plus_plus/helpers/waiting-dialog.dart';
import 'package:converter_plus_plus/mixins/home-mixin.dart';
import 'package:converter_plus_plus/models/media-file.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('directory: $systemDirectory');

          showWaitingDialog(context, operation: () async {
            //TODO: DOIS CASOS PARA VERIFICAR: SE streams FOR VAZIO, NÃO FUNCIONA.
            //TODO: SE codec_type FOR DIFERENTE DOS CADASTRADOS, TAMBÉM NÃO FUNCIONA
            //TODO: PARECE QUE EXISTE UM CODEC subtitle, ENTÃO VERIFICAR E VERIFICAR SVG E ICO TAMBÉM
            try {
              final result = await FilePicker.platform.pickFiles(allowMultiple: true);
              if (result != null) {
                PlatformFile file = result.files.first;
                final streams = await Process.run('C:/Projetos/_meus-projetos/converter_plus_plus/ffprobe.exe', ['-loglevel', '0', '-print_format', 'json', '-show_streams', '${file.path}']);
                final a = MediaFile(file, jsonDecode(streams.stdout)['streams'][0]);
                listFiles.add(a);
              }
            } catch(e,s) {
              print('Erro na importação: $e\n$s');
            }
          });
        },
        backgroundColor: AppTheme.colorScheme.primary,
        child: const Icon(Icons.note_add_rounded),
      ),

      body: Row(
        children: [
          // Lista
          Expanded(
            child: Observer(
              builder: (_) {
                return listFiles.files.isNotEmpty
                ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: listFiles.files.length,
                  itemBuilder: (_, index) => Observer(
                    builder: (_) => ListTile(
                      selectedTileColor: AppTheme.colorScheme.primary.withOpacity(.25),
                      selected: index == listFiles.selectedIndex,
                      tileColor: index%2 == 1 ? AppTheme.colorScheme.secondary : null,
                      leading: Icon(listFiles.files[index].type.icon),
                      trailing: Checkbox(
                        checkColor: Colors.black,
                        value: listFiles.files[index].output.checked,
                        onChanged: (value){
                          listFiles.files[index].output.setChecked(value!);
                        },
                      ),
                      title: Text(listFiles.files[index].fullName),
                      onTap: () {
                        listFiles.setSelectedIndex(index);
                      },
                    ),
                  ),
                )
                : emptyList();
              },
            ),
          ),

          const VerticalDivider(width: 2, color: Colors.white),

          // Formulário
          Expanded(
            child: Observer(
              builder: (context) {
                if(listFiles.files.isNotEmpty) {
                  widthController.text = listFiles.selected.output.size.width.toString();
                  heightController.text = listFiles.selected.output.size.height.toString();
                  extController.text = listFiles.selected.output.format.extension;
                  pathController.text = listFiles.selected.output.path;
                  subtitleController.text = listFiles.selected.output.subtitles;
                  nomeController.text = listFiles.selected.output.name;
                  conversionFormats = listFiles.selected.getConversionFormats();

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    children: [
                      CustomCard(title: 'Saída', children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: pathController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.folderOpen, size: 20),
                                  labelText: 'Pasta de saída',
                                ),
                                onChanged: (value) => listFiles.selected.output.path = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final result = await FilePicker.platform.getDirectoryPath();
                                listFiles.selected.output.path = result ?? '';
                                pathController.text = listFiles.selected.output.path;
                              },
                              icon: const Icon(FontAwesomeIcons.solidFolder, size: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nomeController,
                          onChanged: (value) => listFiles.selected.output.name = value,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.fileSignature, size: 20),
                            labelText: 'Nome do arquivo de saída',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField(
                          onChanged: (value) => listFiles.selected.output.replaceFile = value!,
                          isExpanded: true,
                          value: listFiles.selected.output.replaceFile,
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
                                    if(value != listFiles.selected.output.type) {
                                      listFiles.selected.output.setType(value!);
                                      conversionFormats = listFiles.selected.getConversionFormats();
                                      final format = conversionFormats.first;

                                      if(format == 'Manter') {
                                        listFiles.selected.output.setFormat(format, listFiles.selected.extension);
                                        extController.text = listFiles.selected.extension;
                                      } else {
                                        listFiles.selected.output.setFormat(format, format);
                                        extController.text = format;
                                      }
                                    }
                                  },
                                  decoration: const InputDecoration(),
                                  isExpanded: true,
                                  value: listFiles.selected.output.type,
                                  items: listFiles.selected.getConversionTypes().map((e) {
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
                                      listFiles.selected.output.setFormat(value!, listFiles.selected.extension);
                                      extController.text = listFiles.selected.extension;
                                    } else if(value == 'Customizado') {
                                      listFiles.selected.output.setFormat(value!, '');
                                      extController.text = '';
                                    } else {
                                      listFiles.selected.output.setFormat(value!, value);
                                      extController.text = value;
                                    }
                                  },
                                  decoration: const InputDecoration(),
                                  hint: Text(
                                    'Formato',
                                    style: TextStyle(color: AppTheme.colorScheme.primary),
                                  ),
                                  isExpanded: true,
                                  value: listFiles.selected.output.format.key,
                                  items: conversionFormats.map((e) {
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
                                controller: extController,
                                readOnly: !('Customizado'.contains(listFiles.selected.output.format.key)),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.filePen, size: 20),
                                  labelText: 'Extenção',
                                ),
                              ),
                            )),
                          ],
                        ),
                      ]),

                      if(listFiles.selected.output.type == MediaType.image || listFiles.selected.output.type == MediaType.video)
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
                                        height = listFiles.selected.height;
                                        width = listFiles.selected.width;
                                      } else if(value.descricao == 'Customizado') {
                                        height = width = 0;
                                      } else {
                                        height = value.valor;
                                        width = (height*listFiles.selected.aspectRatio).round();
                                      }

                                      listFiles.selected.output.setSize(value, width, height);
                                      widthController.text = width > 0 ? width.toString() : '';
                                      heightController.text = height > 0 ? height.toString() : '';
                                    },
                                    hint: Text(
                                      'Selecione a qualidade',
                                      style: TextStyle(color: AppTheme.colorScheme.primary),
                                    ),
                                    isExpanded: true,
                                    value: listFiles.selected.output.size.quality,
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
                                  readOnly: listFiles.selected.output.size.quality != MediaQuality.custom,
                                  controller: widthController,
                                  decoration: const InputDecoration(
                                    labelText: 'Largura',
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.close_rounded),
                              ),
                              Expanded(
                                child: Observer(
                                  builder: (_) => TextFormField(
                                    readOnly: listFiles.selected.output.size.quality != MediaQuality.custom,
                                    controller: heightController,
                                    decoration: const InputDecoration(
                                      labelText: 'Altura',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),

                      if(listFiles.selected.output.type == MediaType.video) CustomCard(title: 'Legendas', children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: subtitleController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.closedCaptioning, size: 20),
                                  labelText: 'Arquivo de legenda',
                                ),
                                onChanged: (value) => listFiles.selected.output.subtitles = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['srt', 'ass']);
                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  listFiles.selected.output.subtitles = file.path ?? '';
                                } else {
                                  listFiles.selected.output.subtitles = '';
                                }

                                subtitleController.text = listFiles.selected.output.subtitles;
                              },
                              icon: const Icon(FontAwesomeIcons.solidFolder, size: 20),
                            ),
                          ],
                        ),
                      ]),

                      CustomCard(title: 'Converter', children: [
                        Container(
                          decoration: boxDecoration,
                          child: ListTile(
                            trailing: Switch(
                              value: useSameSettings,
                              onChanged: (value) => useSameSettings = value,
                            ),
                            title: const Text('Usar essas configurações em todos os arquivos selecionados'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: boxDecoration,
                          child: ListTile(
                            trailing: Switch(
                              value: convertAll,
                              onChanged: (value) => convertAll = value,
                            ),
                            title: const Text('Converter todos os arquivos selecionados'),
                          ),
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: (){
                            print('---------------------------------------------');
                            print(listFiles.selected.toString());
                            print('---------------------------------------------');
                          },
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

                return emptyForm();
              }
            ),
          ),
        ],
      ),
    );
  }
}