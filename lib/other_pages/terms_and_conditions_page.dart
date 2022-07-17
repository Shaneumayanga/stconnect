import 'package:flutter/material.dart';
class TermsAndConditionsPage extends StatefulWidget {
  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  String str = ''' 
  
Welcome to Stconnect!

These terms and conditions outline the rules and regulations for the use of Stconnect.

By using this Application we assume you accept these terms and conditions. Do not continue to use Stconnect if you do not agree to take all of the terms and conditions stated on this page.

The following terminology applies to these Terms and Conditions, 
Privacy Statement and Disclaimer Notice and all Agreements: 
"Client", "You" and "Your" refers to you, the person log on this website and compliant to the Company’s terms and conditions. 
"The Company", "Ourselves", "We", "Our" and "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves.
 All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner 
for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. 
Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.



License
Unless otherwise stated, Stconnect and/or its licensors own the intellectual property rights for all material on Stconnect. All intellectual property rights are reserved. You may access this from Stconnect for your own personal use subjected to restrictions set in these terms and conditions.

You must not:

*Republish material from Stconnect
*Sell, rent or sub-license material from Stconnect
*Reproduce, duplicate or copy material from Stconnect
*Redistribute content from Stconnect
*decompiles, reverse engineers, or otherwise attempts to obtain the source 
 code or underlying ideas or information of or relating to the Services.
*post hate speech, sexual content/ inappropriate content , profanity 

This Agreement shall begin on the date hereof. 


This app allows users to register as a Student or a Teacher, and a User who is registering as a teacher is offered an opportunity to share the subjects
that he/she teach and basic contact info including emails , phonenumber , Stconnect does not filter, edit, publish or review these details prior to their presence on the Application.
Stconnect shall not be liable for the details or for any liability, 
damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the details on this Application.


Stconnect reserves the right to monitor all Account details/posts (in the form of Questions)/comments(in the form of answers)and to remove any which can be considered inappropriate, 
offensive or causes breach of these Terms and Conditions.

You warrant and represent that:

You are entitled to post the Account details asked on our Application and have all necessary licenses and consents to do so;
The Account details do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;
The Account details do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy
The Account details will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.
You hereby grant Stconnect a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.

Hyperlinking to our Content
The following organizations may link to our Application without prior written approval:

Government agencies;
Search engines;
News organizations;
Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and
System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.
These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.

We may consider and approve other link requests from the following types of organizations:

commonly-known consumer and/or business information sources;
dot.com community sites;
associations or other groups representing charities;
online directory distributors;
internet portals;
accounting, law and consulting firms; and
educational institutions and trade associations.

Your Privacy
Please read Privacy Policy

Reservation of Rights
We reserve the right to request that you remove all links or any particular link to our Application.
You approve to immediately remove all links to our Application upon request. 
We also reserve the right to amen these terms and conditions and it’s linking policy at any time. 
By continuously linking to our Application,you agree to be bound to and follow these linking terms and conditions.

Removal of links from our Application. 
If you find any link on our Application. that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.

We do not ensure that the information on this Application is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the Application remains available or that the material on the website is kept up to date.

Disclaimer
Please read Disclaimer
 
  
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
      ),
      body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              "$str",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 800,
            ),
          )),
    );
  }
}

