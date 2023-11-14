import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ir_simulation/misc/lib_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ir_simulation/pages/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../cubit/app_cubits.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    //print(globals.sharedPreferences?.getString('email'));

    super.initState();
  }

  final RoundedLoadingButtonController googleController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController gitController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController twitterController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController = RoundedLoadingButtonController();
  
  FirebaseAuth? firebaseAuth;
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
    clientId: LibData.clientIdGit,
    clientSecret: LibData.clientSecretGit,
    redirectUrl: LibData.redirectUrlGit,
    title: LibData.titleGit,
    centerTitle: LibData.centerTitleGit,
    scope: 'user:email'
  );

  User? user;
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      firebaseAuth = FirebaseAuth.instance;
      UserCredential? userCredential = await firebaseAuth?.signInWithCredential(credential);

      return userCredential;

   // return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  Future<UserCredential?> signInWithGithub(BuildContext context) async {

    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:

        final githubAuthCredential = GithubAuthProvider.credential(result.token.toString());
        firebaseAuth = FirebaseAuth.instance;
        final UserCredential? userCredential = await firebaseAuth?.signInWithCredential(githubAuthCredential);
        return userCredential;

      case GitHubSignInResultStatus.cancelled:
        gitController.reset();
        return null;
      case GitHubSignInResultStatus.failed:
        gitController.reset();
        return null;
    }
  }

  Future<UserCredential?> signInWithTwitter() async{
    final twitterLogin = TwitterLogin(
        apiKey: 'Ln7Wp6jeJA0Af895PSlyMwjpu',
        apiSecretKey: 'FhDDf7uibYviWXYOCJuyHkQFyTmZ5Q8XmmsC0m7QK4vfyYFFJf',
        redirectURI: 'flutter-twitter-login://'
    );

    final authResult = await twitterLogin.login();

    final twitterAuthCredential = TwitterAuthProvider.credential(
      accessToken: authResult.authToken!,
      secret: authResult.authTokenSecret!,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(twitterAuthCredential);

  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
     final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
   //final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential('EAAMbYeOWX88BO1TJON1i2TngWHEE1v6CXVtSPPklQZCBPmQesioXZBu7FGDjainy1ZASqNr0ZCMrmT0ATYUKwr3xW8LEAsxUXczEagYvqpc8OJWegaZBYrQr2olGKbZC8qLDhBFkz5nxVnvIuZARw3YC17GHuOB4cpwe9pOsDs5fWtEhY9936jbdn1e3JWjUBl6mtLAR5jAH5jrkn3QEWi7S4oJ1UDZCdRs5Eu2aXuPrnOvZBhNVE3ZCOKnNe542RW8KfitbamggZDZD');
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  String? getEmailFromServerResponseUser(){

    if( this.user?.email != null ){
      return this.user?.email!;
    }

    if( this.user?.providerData[0].email! != null ){
      return this.user?.providerData[0].email!;
    }

    return null;

  }

  Future<void> logout() async{

    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    FirebaseAuth.instance.signOut();
    gitController.reset();
    googleController.reset();
    twitterController.reset();
    facebookController.reset();
    firebaseAuth = null;

    setState(() {
      user = null;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              decoration :const BoxDecoration(
                color : Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                AppLocalizations.of(context)!.loginTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: 370,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "img/login/login.jpg",
                  ),
                  fit: BoxFit.fitWidth
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 40
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: 60,
                    margin: const EdgeInsets.only(
                        bottom: 10,
                        right: 8
                    ),
                    child: RoundedLoadingButton(
                      successColor: Colors.green,
                      color: Colors.red,
                      controller: googleController,onPressed: () async {
                      UserCredential? usercred;
                      try {
                        usercred = await signInWithGoogle();
                      }catch(e){
                        print(e);
                        googleController.reset();
                      }
                      if(usercred!.user != null)
                      {
                        googleController.success();
                        setState(() {
                          user = usercred!.user;
                        });
                        globals.sharedPreferences!.setString('email', '${getEmailFromServerResponseUser()}');
                        BlocProvider.of<AppCubits>(context).goToMain();
                      }
                    }, child: const Wrap(
                        children: [
                          Icon(FontAwesomeIcons.google,color: Colors.white,size: 18,)
                        ],
                      )
                    ),
                  ),
                  Container(
                    width: 60,
                    margin: const EdgeInsets.only(
                        bottom: 10,
                        right: 8
                    ),
                    child: RoundedLoadingButton(
                        successColor: Colors.green,
                        color: Colors.blue,
                        controller: twitterController,onPressed: () async {

                      UserCredential? usercred;
                      try {
                        usercred = await signInWithTwitter();
                      }catch(e){
                        print(e);
                        twitterController.reset();
                      }
                      if(usercred!.user != null)
                      {
                        twitterController.success();
                        setState(() {
                          user = usercred!.user;
                        });
                        globals.sharedPreferences!.setString('email', '${getEmailFromServerResponseUser()}');
                        BlocProvider.of<AppCubits>(context).goToMain();
                      }

                    }, child: const Wrap(
                      children: [
                        Icon( FontAwesomeIcons.twitter,color: Colors.white,size: 18, )
                      ],
                    )
                    ),
                  ),
                  Container(
                    width: 60,
                    margin: const EdgeInsets.only(
                        bottom: 10,
                        right: 8
                    ),
                    child: RoundedLoadingButton(
                        successColor: Colors.green,
                        color: Colors.black45,
                        controller: gitController,onPressed: () async {
                      UserCredential? usercred;
                      try {
                        usercred = await signInWithGithub(context);
                      }catch(e){
                        print(e);
                        gitController.reset();
                      }
                      if(usercred!.user != null)
                      {
                        gitController.success();
                        setState(() {
                          user = usercred!.user;
                        });
                        globals.sharedPreferences!.setString('email', '${getEmailFromServerResponseUser()}');
                        BlocProvider.of<AppCubits>(context).goToMain();
                      }

                    }, child: const Wrap(
                      children: [
                        Icon(FontAwesomeIcons.github,color: Colors.white,size: 18,)
                      ],
                    )
                    ),
                  ),
                 /* Container(
                    width: 60,
                    margin: const EdgeInsets.only(
                        bottom: 10
                    ),
                    child: RoundedLoadingButton(
                        successColor: Colors.green,
                        color: Colors.blue,
                        controller: facebookController,onPressed: () async {

                      UserCredential? usercred;
                        try{

                          usercred = await signInWithFacebook();
                          print("roto_suc");
                          print(usercred.user);
                        }catch(e){
                          print(e);
                          facebookController.reset();
                        }

                        if(usercred!.user != null)
                        {
                          facebookController.success();
                          setState(() {
                            user = usercred!.user;
                          });
                        }


                    }, child: const Wrap(
                      children: [
                        Icon( FontAwesomeIcons.facebook,color: Colors.white,size: 18, )
                      ],
                    )
                    ),
                  ),*/
                ],
              ),
            ),
            Container(
              width: 300,
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.loginMSG),
                ],
              ),
            )

            /*IconButton(
                color: Colors.red,
                onPressed: () async{
                  print(this.user!.providerData[0].email);
                }, icon: const Icon(Icons.ac_unit) ),
            Text(user?.email==null?"Not logged in":"${user?.email}"),*/

          ],
        ),
      ),
    );
  }
}


