
QRK
===

[PoC] Music blogging project

=======



# Welcome

Creating a proof of concept, lightweight player for my music blog http://quark-up.tumblr.com

# The blog

Concept has been declined a zillion times, nothing very particular, same-ol' tumblr. Twitter has been post-integrated.

Unfortunately due to lack of time / motivation, the website has been put on hold after a year and half posting (almost) a song a day (keeping the doctor away).

# The idea

Just for fun, on one of those late night hungers you get for knowledge / ideas (am I weird ?), I decided to pull up my old blog. After a few HTML / PHP bloggy tests, I decided to go for an app. Just so happened I was on soundcloud at the time so decided to use their API. 

##Views :
* Articles (fetched from tumblr API probably)
* Playlists (Soundcloud API, regular JSON parsing with SC queries)
* Contacts (propose a song, social integration)

## Other views = Maybes / toDos
* Show user's favorites on SC

# Deprecation Fixes to standard APIs
## JSONKit : 
* replace " object->isa " by  " object_getClass(object) " since direct access to isa is deprecated
* ignore the " bitmasking is discouraged "

## SoundCloudUI :
* change ''' - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
 ''' to ''' - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations '''
* change UILineBreakModeWordWrap to NSLineBreakByWordWrapping
* change ''' [addCustomLink:[NSURL URLWithString:kTermsOfServiceURL] inRange:touLinkRange]; ''' to ''' setLink:[NSURL URLWithString:kTermsOfServiceURL]
                         range:touLinkRange]; ''' (same for privacy policy)
* change ''' [self.navigationController presentModalViewController:controller animated:YES]; ''' to ''' [self.navigationController presentViewController:controller animated:YES completion:nil]; ''' (equivalent changes to dismissModalViewController)
* change all text alignments from UIText(...) to NSText(...)

A couple more coming


