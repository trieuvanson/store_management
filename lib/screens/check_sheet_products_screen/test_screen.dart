import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/test-screen';

  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final menuTree = <Map<String, dynamic>>[
    {
      'name': 'Menu 1',
      'children': [
        {
          'name': 'Menu 1.1',
          'children': [
            {
              'name': 'Menu 1.1.1',
              'children': <Map<String, dynamic>>[

              ],
            },
            {
              'name': 'Menu 1.1.2',
              'children': <Map<String, dynamic>>[],
            },
          ],
        },
        {
          'name': 'Menu 1.2',
          'children': <Map<String, dynamic>>[
            {
              'name': 'Menu 1.2.1',
              'children': <Map<String, dynamic>>[],
            },
            {
              'name': 'Menu 1.2.2',
              'children': <Map<String, dynamic>>[],
            },
          ],
        },
      ],
    },
    {
      'name': 'Menu 2',
      'children': <Map<String, dynamic>>[
        {
          'name': 'Menu 2.1',
          'children': <Map<String, dynamic>>[
            {
              'name': 'Menu 2.1.1',
              'children': <Map<String, dynamic>>[],
            },
            {
              'name': 'Menu 2.1.2',
              'children': <Map<String, dynamic>>[],
            },
          ],
        },
        {
          'name': 'Menu 2.2',
          'children': <Map<String, dynamic>>[
            {
              'name': 'Menu 2.2.1',
              'children': <Map<String, dynamic>>[
                {
                  'name': 'Menu 2.2.1.1',
                  'children': <Map<String, dynamic>>[],
                },
                {
                  'name': 'Menu 2.2.2.2',
                  'children': <Map<String, dynamic>>[],
                },
              ],
            },
            {
              'name': 'Menu 2.2.2',
              'children': <Map<String, dynamic>>[],
            },
          ],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: outputMenuTree(menuTree, 0),
      ),
    );
  }

  Widget outputMenuTree(List<Map<String, dynamic>> tree, int level) {
    if (tree == null || tree.isEmpty) {
      return Container();
    }

    return Column(
      children: List.generate(tree.length, (index) {
        final node = tree[index];
        return Container(
          margin: EdgeInsets.only(left: level * 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '- ${node['name']}',
                style: TextStyle(fontSize: 18.0),
              ),
              outputMenuTree(node['children'], level + 1),
            ],
          ),
        );
      }),
    );
  }
}
