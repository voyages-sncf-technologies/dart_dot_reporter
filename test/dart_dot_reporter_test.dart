import 'dart:io';

import 'package:dart_dot_reporter/dot_reporter.dart';
import 'package:dart_dot_reporter/model.dart';
import 'package:dart_dot_reporter/parser.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  test('TestModel', () {
    final model = TestModel();
    expect(model.id, null);
    expect(model.name, null);
    expect(model.error, null);
    expect(model.state, null);
  });

  group('parser', () {
    test('can parse file with lines containing json', () async {
      final parser = Parser();

      await parser.parseFile('./test/machine_sample.log');

      expect(parser.tests.keys, [1, 27, 5, 28, 29, 30, 31]);
      expect(
          parser.tests[27],
          TestModel()
            ..id = 27
            ..state = State.Success
            ..name = 'API getAll');
      expect(
          parser.tests[28],
          TestModel()
            ..id = 28
            ..state = State.Skipped
            ..name = 'API delete');
      expect(
          parser.tests[29],
          TestModel()
            ..id = 29
            ..state = State.Failure
            ..error =
                "\tExpected: {\n            'id': 103\n          }\n  Actual: {\n            'ids': 102,\n          }\n   Which: is missing map key 'id'\n"
            ..name = 'API update');
      expect(
          parser.tests[30],
          TestModel()
            ..id = 30
            ..name = 'API create');
      expect(
          parser.tests[31],
          TestModel()
            ..id = 31
            ..state = State.Failure
            ..error = null
            ..message =
                '''\t══╡ EXCEPTION CAUGHT BY WIDGETS LIBRARY ╞═══════════════════════════════════════════════════════════\nThe following NoSuchMethodError was thrown building Button(dirty, dependencies:\n[Theme]):\nThe getter 'theme' was called on null.\nReceiver: null\nTried calling: theme\n\nWidget creation tracking is currently disabled. Enabling it enables improved error messages. It can\nbe enabled by passing `--track-widget-creation` to `flutter run` or `flutter test`.\n\nWhen the exception was thrown, this was the stack:\n#0      Object.noSuchMethod (dart:core-patch/object_patch.dart:51:5)\n#1      Theme.of (package:app/theme/theme.dart:59:10)\n#2      Button.build (package:app/widget/button.dart:32:28)\n#3      StatelessElement.build (package:flutter/src/widgets/framework.dart:4009:28)\n#4      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:3941:15)\n#5      Element.rebuild (package:flutter/src/widgets/framework.dart:3738:5)\n#6      ComponentElement._firstBuild (package:flutter/src/widgets/framework.dart:3924:5)\n#7      ComponentElement.mount (package:flutter/src/widgets/framework.dart:3919:5)\n#8      Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#9      Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#10     SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5127:14)\n#11     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#12     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#13     SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5127:14)\n#14     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#15     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#16     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:3961:16)\n#17     Element.rebuild (package:flutter/src/widgets/framework.dart:3738:5)\n#18     ComponentElement._firstBuild (package:flutter/src/widgets/framework.dart:3924:5)\n#19     ComponentElement.mount (package:flutter/src/widgets/framework.dart:3919:5)\n#20     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#21     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#22     SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5127:14)\n#23     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#24     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#25     SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5127:14)\n#26     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#27     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#28     SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5127:14)\n#29     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#30     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#31     SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:5127:14)\n#32     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#33     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#34     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:3961:16)\n#35     Element.rebuild (package:flutter/src/widgets/framework.dart:3738:5)\n#36     ComponentElement._firstBuild (package:flutter/src/widgets/framework.dart:3924:5)\n#37     StatefulElement._firstBuild (package:flutter/src/widgets/framework.dart:4088:11)\n#38     ComponentElement.mount (package:flutter/src/widgets/framework.dart:3919:5)\n#39     Element.inflateWidget (package:flutter/src/widgets/framework.dart:3101:14)\n#40     Element.updateChild (package:flutter/src/widgets/framework.dart:2904:12)\n#41     ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:3961:16)\n#42     Element.rebuild (package:flutter/src/widgets/framework.dart:3738:5)\n#43     ComponentElement._firstBuild (package:flutter/src/widgets\n(elided 36 frames from class _FakeAsync, package dart:async, package dart:async-patch, and package stack_trace)\n\n════════════════════════════════════════════════════════════════════════════════════════════════════\n'''
            ..name = 'API too big print text');
      expect(
          parser.tests[5],
          TestModel()
            ..id = 5
            ..state = State.Error
            ..error =
                '''\tThis test failed after it had already completed. Make sure to use [expectAsync]\nor the [completes] matcher when testing async code.\n'''
            ..message = null
            ..name =
                'Cubit emits [LoadInProgress(),LoadSuccess()] when product found');
      expect(parser.success, false);
    });
  });

  group('dot_reporter', () {
    DotReporter reporter;
    Parser parser;
    OutMock out;

    final loadingTest = TestModel()
      ..id = 0
      ..name = 'loading /User/home... any path to .dart file';

    final failureWithErrorWithMessageTest = TestModel()
      ..id = 2
      ..name = 'error name'
      ..state = State.Failure
      ..error =
          "Expected: {\n            'id': 103\n          }\n  Actual: {\n            'ids': 102,\n          }\n   Which: is missing map key 'id'\n";

    final messageTest = TestModel()
      ..id = 31
      ..state = State.Failure
      ..error = null
      ..message = 'A very long message'
      ..name = 'message name';

    final successTest = TestModel()
      ..id = 1
      ..name = 'success name'
      ..state = State.Success;

    final failureTest = TestModel()
      ..id = 2
      ..name = 'error name'
      ..state = State.Failure;

    final errorTest = TestModel()
      ..id = 2
      ..name = 'error name'
      ..error = 'error message'
      ..state = State.Error;

    final skippedTest = TestModel()
      ..id = 3
      ..name = 'skipped name'
      ..state = State.Skipped;

    setUp(() {
      exitCode = 0;
      parser = Parser();
      out = OutMock();
      reporter = DotReporter(
        noColor: true,
        out: out,
        parser: parser,
      );
    });

    test('Ignore "loading" tests', () {
      parser.tests[loadingTest.id] = loadingTest;
      reporter.printReport();
      expect(exitCode, 0);
      verify(out.write('')).called(2);
      verify(out.writeln()).called(5);
      verify(out.writeAll(
        [
          'Total: 0',
          'Success: 0',
          'Skipped: 0',
          'Failure: 0',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('Single success test passed', () {
      parser.tests[successTest.id] = successTest;
      reporter.printReport();
      expect(exitCode, 0);
      verify(out.write('.')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('')).called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 1',
          'Skipped: 0',
          'Failure: 0',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('Single failed test passed', () {
      parser.tests[failureTest.id] = failureTest;
      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('X')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('X error name')).called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 0',
          'Skipped: 0',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('Single error test passed', () {
      parser.tests[errorTest.id] = errorTest;
      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('X')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('X error name')).called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 0',
          'Skipped: 0',
          'Failure: 0',
          'Error: 1',
        ],
        '\n',
      )).called(1);
    });

    test('Single error with message test passed', () {
      parser.tests[failureWithErrorWithMessageTest.id] =
          failureWithErrorWithMessageTest;
      reporter = DotReporter(
        noColor: true,
        showMessage: true,
        out: out,
        parser: parser,
      );
      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('X')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write(
              "X error name\nExpected: {\n            'id': 103\n          }\n  Actual: {\n            'ids': 102,\n          }\n   Which: is missing map key 'id'\n"))
          .called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 0',
          'Skipped: 0',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('Complex error with message test passed', () {
      parser.tests[messageTest.id] = messageTest;
      reporter = DotReporter(
        noColor: true,
        showMessage: true,
        out: out,
        parser: parser,
      );
      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('X')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('X message name\nA very long message')).called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 0',
          'Skipped: 0',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('Single skip test passed', () {
      parser.tests[skippedTest.id] = skippedTest;
      reporter.printReport();
      expect(exitCode, 0);
      verify(out.write('!')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('! skipped name')).called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 0',
          'Skipped: 1',
          'Failure: 0',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });
    test('Single skip test failed if flag is passed', () {
      parser.tests[skippedTest.id] = skippedTest;
      reporter = DotReporter(
        noColor: true,
        out: out,
        parser: parser,
        failSkipped: true,
      );
      reporter.printReport();
      expect(exitCode, 1);
      verify(out.write('!')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('! skipped name')).called(1);
      verify(out.writeAll(
        [
          'Total: 1',
          'Success: 0',
          'Skipped: 1',
          'Failure: 0',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('All tests passed', () {
      parser.tests[successTest.id] = successTest;
      parser.tests[failureTest.id] = failureTest;
      parser.tests[skippedTest.id] = skippedTest;

      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('.X!')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('X error name\n! skipped name')).called(1);
      verify(out.writeAll(
        [
          'Total: 3',
          'Success: 1',
          'Skipped: 1',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });

    test('hide skipped', () {
      parser.tests[successTest.id] = successTest;
      parser.tests[failureTest.id] = failureTest;
      parser.tests[skippedTest.id] = skippedTest;
      reporter = DotReporter(
        noColor: true,
        out: out,
        parser: parser,
        hideSkipped: true,
      );

      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('.X!')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('X error name')).called(1);
      verify(out.writeAll(
        [
          'Total: 3',
          'Success: 1',
          'Skipped: 1',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });
    test('show Id of the test', () {
      parser.tests[successTest.id] = successTest;
      parser.tests[failureTest.id] = failureTest;
      parser.tests[skippedTest.id] = skippedTest;
      reporter = DotReporter(
        noColor: true,
        out: out,
        parser: parser,
        showId: true,
      );

      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('.X!')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('2 X error name\n3 ! skipped name')).called(1);
      verify(out.writeAll(
        [
          'Total: 3',
          'Success: 1',
          'Skipped: 1',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });
    test('show successfull tests in list', () {
      parser.tests[successTest.id] = successTest;
      parser.tests[failureTest.id] = failureTest;
      parser.tests[skippedTest.id] = skippedTest;
      reporter = DotReporter(
        noColor: true,
        out: out,
        parser: parser,
        showSuccess: true,
      );

      reporter.printReport();
      expect(exitCode, 2);
      verify(out.write('.X!')).called(1);
      verify(out.writeln()).called(5);
      verify(out.write('. success name\nX error name\n! skipped name'))
          .called(1);
      verify(out.writeAll(
        [
          'Total: 3',
          'Success: 1',
          'Skipped: 1',
          'Failure: 1',
          'Error: 0',
        ],
        '\n',
      )).called(1);
    });
  });
}

class OutMock extends Mock implements Stdout {}
