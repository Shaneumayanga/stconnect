import 'package:flutter/material.dart';

class DisclaimerPage extends StatefulWidget {
  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  String str = ''' 
If you require any more information or have any questions about our application's (Stconnect) disclaimer,
please feel free to contact us by email at shaneumayanga445@gmail.com

Disclaimers for Stconnect

All the information on this application is published in good faith and for general information purpose only. 
Stconnect does not make any warranties about the completeness, reliability and accuracy of this information. 
Any action you take upon the information you find on this application(Stconnect), is strictly at your own risk.
Stconnect will not be liable for any losses and/or damages in connection with the use of our application


From our application you can visit other websites by following hyperlinks to such external sites.
While we strive to provide only quality links to useful and ethical websites, 
we have no control over the content and nature of these sites. 
These links to other websites do not imply a recommendation for all the content found on these sites.
Site owners and content may change without notice and may occur before we have the opportunity to remove a link which may have gone 'bad'.

Please be also aware that when you leave our application,other sites may have different privacy policies and terms which are beyond our control.
Please be sure to check the Privacy Policies of these sites as well as their "Terms of Service" before engaging in any business or uploading any information.

Consent

By using our application, you hereby consent to our disclaimer and agree to its terms

Update

Should we update, amend or make any changes to this document, those changes will be prominently posted here.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer for Stconnect"),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            str,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 36,
          ),
        ),
      ),
    );
  }
}
