#!usr/bin/perl
############################################################################
#@(#) Functie: Print de leeftijd  van een bepaald bestand.
#@(#) Datum: 12-03-2007    
#@(#) Auteur: R de Gunst
#@(#) $Date: 2010-05-19 11:54:52 +0200 (wo, 19 mei 2010) $
############################################################################
# SCRIPTS ONDERHOUDEN OP ROOD EN DAARNA DISTRIBUEREN. NIET DECENTRAAL AANPASSEN
############################################################################

# Include van de benodigde libaries.
use Time::localtime;
use File::stat qw(stat);
# Eerste argument is de filename.
$filename = "$ARGV[0]";
# Tweede argument is de optie om te tonen in minuten ipv uren. [-m]
$minuten = "$ARGV[1]";
# Timestamp van dit moment. (in seconden t.o.v. epoch)
my $now = time();
# Bestaat de file?
if (-e $filename)
 {
  # Timestamp van de file.
  my $mtime = stat($filename)->mtime;
    # Controleer of optie [-m] meegegeven is
    if ($minuten eq "-m") {
      # Print de ouderdom van het bestand in minuten.
	  print int(($now - $mtime)/60) . "\n";
    }
    else {
      # Print de ouderdom van het bestand in uren.
	  print int(($now - $mtime)/3600) . "\n";
    }
 } else {
  # Print 0 indien het bestand niet bestaat.
  print "0\n";
 }
