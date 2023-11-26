import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Auth-Provider.dart';

class AuthRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final Auth_Provider authProvider;

  AuthRouteObserver(this.authProvider);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route.settings.name != '/login' && route.settings.name != '/signup') {
      // If the route is not login/signup, check authentication status
      if (authProvider.user == null) {
        // If user not authenticated, push to login page
        navigator?.pushNamed('/login');
      }
    }
  }
}
