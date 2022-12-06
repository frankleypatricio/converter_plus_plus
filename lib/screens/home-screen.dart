import 'package:converter_plus_plus/components/custom-card.dart';
import 'package:converter_plus_plus/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final itens = ['.mp3', '.mp4', '.png', 'Customizado'];
  final qualidades = ['144p', '240p', '360p', '480p', '720p', '1080p', 'Customizado'];
  String? selected;
  String? qSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.colorScheme.primary,
        child: const Icon(Icons.note_add_rounded),
      ),

      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: 10,
              itemBuilder: (_, index) => ListTile(
                tileColor: index%2 == 1 ? AppTheme.colorScheme.primary.withOpacity(.25) : null,
                leading: const Icon(FontAwesomeIcons.solidFileVideo),
                trailing: Checkbox(
                  checkColor: Colors.black,
                  value: true,
                  onChanged: (_){},
                ),
                title: const Text('video.mp4'),
              ),
              /*children: [
                ListTile(
                  tileColor: AppTheme.colorScheme.primary.withOpacity(.25),
                  leading: const Icon(FontAwesomeIcons.solidFileImage),
                  title: const Text('image.png'),
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.solidFileVideo),
                  trailing: Checkbox(
                    checkColor: Colors.black,
                    value: true,
                    onChanged: (_){},
                  ),
                  title: const Text('video.mp4'),
                ),
                ListTile(
                  tileColor: AppTheme.colorScheme.primary.withOpacity(.25),
                  leading: const Icon(FontAwesomeIcons.solidFileAudio),
                  title: const Text('audio.mp3'),
                ),
              ],*/
            ),
          ),

          const VerticalDivider(width: 2, color: Colors.white),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              children: [
                CustomCard(title: 'Saída', children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.folderOpen, size: 20),
                            labelText: 'Pasta de saída',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.solidFolder, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.fileSignature, size: 20),
                      labelText: 'Nome do arquivo de saída',
                    ),
                  ),
                ]),

                CustomCard(title: 'Qualidade', children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          onChanged: (String? s) => setState(() => qSelected = s),
                          hint: Text(
                            'Selecione a qualidade',
                            style: TextStyle(color: AppTheme.colorScheme.primary),
                          ),
                          isExpanded: true,
                          value: qSelected,
                          items: qualidades.map((i) {
                            return DropdownMenuItem(
                              value: i,
                              child: Text(i),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.end,
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Altura',
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),

                CustomCard(title: 'Formato', children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          onChanged: (String? s) => setState(() =>selected = s),
                          decoration: const InputDecoration(),
                          hint: Text(
                            'Selecione o formato',
                            style: TextStyle(color: AppTheme.colorScheme.primary),
                          ),
                          isExpanded: true,
                          value: selected,
                          items: itens.map((i) {
                            return DropdownMenuItem(
                              value: i,
                              child: Text(i),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(FontAwesomeIcons.filePen, size: 20),
                          labelText: 'Formato',
                        ),
                      )),
                    ],
                  ),
                ]),

                CustomCard(title: 'Legendas', children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(FontAwesomeIcons.closedCaptioning, size: 20),
                            labelText: 'Arquivo de legenda',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.solidFolder, size: 20),
                      ),
                    ],
                  ),
                ]),

                CustomCard(title: 'Converter', children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.colorScheme.primary, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                      ),
                      title: const Text('Usar essas configurações em todos os arquivos'),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: (){},
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
            ),
          ),
        ],
      ),
    );
  }
}