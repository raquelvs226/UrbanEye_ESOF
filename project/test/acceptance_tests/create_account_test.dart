import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/main.dart';
 
void main() {
  group('US01 - Create new account', () {
 
    // Navigates to the register screen before each test
    Future<void> navigateToRegisterScreen(WidgetTester tester) async {
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('registerButton')));
      await tester.pumpAndSettle();
    }
 
    // Fills the registration form with the provided data
    Future<void> fillRegisterForm(
      WidgetTester tester, {
      String name = 'Raquel Silva',
      String birthDate = '22/03/2006',
      String username = 'raquel11',
      String email = 'raquel11@email.com',
      String password = 'Password123!',
    }) async {
      await tester.enterText(find.byKey(const Key('nameField')), name);
      await tester.pump();
      await tester.enterText(find.byKey(const Key('birthDateField')), birthDate);
      await tester.pump();
      await tester.enterText(find.byKey(const Key('usernameField')), username);
      await tester.pump();
      await tester.enterText(find.byKey(const Key('emailField')), email);
      await tester.pump();
      await tester.enterText(find.byKey(const Key('passwordField')), password);
      await tester.pump();
    }
 
    // Scenario: Registration with valid data
    testWidgets(
      'Scenario 1: User fills in all fields correctly and is redirected to Home',
      (tester) async {
        await navigateToRegisterScreen(tester);
        await fillRegisterForm(tester);
 
        await tester.tap(find.byKey(const Key('createAccountButton')));
        await tester.pumpAndSettle();
 
        // Should redirect to the main screen
        expect(find.byKey(const Key('homeScreen')), findsOneWidget);
      },
    );
 
    // Scenario: Required fields left blank
    testWidgets(
      'Scenario 2: User attempts to create an account without filling in required fields',
      (tester) async {
        await navigateToRegisterScreen(tester);
 
        // Submits without filling in anything
        await tester.tap(find.byKey(const Key('createAccountButton')));
        await tester.pumpAndSettle();
 
        // Should remain on the register screen and show errors
        expect(find.byKey(const Key('registerScreen')), findsOneWidget);
        expect(find.text('Campo obrigatório'), findsWidgets);
      },
    );
 
    // Scenario: Email with invalid format
    testWidgets(
      'Scenario 3: User enters an email with an invalid format',
      (tester) async {
        await navigateToRegisterScreen(tester);
        await fillRegisterForm(tester, email: 'emailinvalido');
 
        await tester.tap(find.byKey(const Key('createAccountButton')));
        await tester.pumpAndSettle();
 
        expect(find.byKey(const Key('registerScreen')), findsOneWidget);
        expect(find.text('Email inválido'), findsOneWidget);
      },
    );
 
    // Scenario: Username already taken
    testWidgets(
      'Scenario 4: User attempts to register with an already existing username',
      (tester) async {
        await navigateToRegisterScreen(tester);
        await fillRegisterForm(tester, username: 'utilizador_existente');
 
        await tester.tap(find.byKey(const Key('createAccountButton')));
        await tester.pumpAndSettle();
 
        expect(find.byKey(const Key('registerScreen')), findsOneWidget);
        expect(find.text('Nome de utilizador já existe'), findsOneWidget);
      },
    );
 
    // Scenario: Already registered user navigates to Login
    testWidgets(
      'Scenario 5: User with an existing account clicks "Already have an account" and is redirected to Login',
      (tester) async {
        await navigateToRegisterScreen(tester);
 
        await tester.tap(find.byKey(const Key('goToLoginButton')));
        await tester.pumpAndSettle();
 
        expect(find.byKey(const Key('loginScreen')), findsOneWidget);
      },
    );
  });
}