#!/usr/bin/perl
use strict;
use warnings;

use PostScript::Simple;
use Barcode::Code128 qw(:all);
use GD::Barcode::QRcode;
use Text::Iconv;

my $conv = Text::Iconv->new("utf8", "cp1251");
 
# create a new PostScript object
my $p = new PostScript::Simple(
#														papersize => "A4",
                            xsize => (90/25.4)*72,
                            ysize => (60/25.4)*72,
                            colour => 1,
                            eps => 0,
                            units => "mm");

sub qrcode
{
	my $bc = shift;
	my $xpos = shift;
	my $ypos = shift;
	my $width = shift;
	system("qrencode -t EPS -o /tmp/asdf.eps $bc");
	$p->importepsfile( {overlap => 1}, "/tmp/asdf.eps", $xpos, $ypos, $xpos+$width, $ypos+$width);	
}

sub barcode
{
    my $bccontents = $_[0];
    my $oGdB = new Barcode::Code128;
    $oGdB->text(FNC1.$bccontents);

    my $sPtn = $oGdB->barcode(FNC1.$bccontents)." ";
    my @barcode = split(//, $sPtn);

    my $vbialo=0;
    my $off=$_[3];
    my $off1=$_[3];

#    print "asd".$sPtn."\n";
    for my $op (0..length($sPtn)-1)
    {
                if ($barcode[$op] eq " " and $vbialo==0) {
                        $vbialo=1;$p->box({filled=>1},sprintf("%.6f",$off),$_[1],sprintf("%.6f",$off1),$_[1]+8)
		}
                if ($barcode[$op] eq "#" and $vbialo==1) {
			$vbialo=0;$off1=$off;
		}
        $off=$off+0.18;
    }
}

sub grid
{
	$p->setlinewidth(0.1);
    for (my $x=0;$x<297;$x+=5)
    {
		$p->line($x, 0, $x, 420); 
	}
    for (my $y=0;$y<=420;$y+=5)
    {
        $p->line(0, $y, 297, $y);
    }
}

my $kashon=1;

my @files = <./*.txt>;
foreach my $file (@files)
{
        print "$file\n";

        $file =~ m/(\d{2})_(.*)\.txt$/;

			  my $number = $1;
				my $name = $2;
        print "NUMBER: $number\t NAME: $name\n";

				my $smes;
				my $line1;
				my $line2;
				my $line3;
				my $sign1;
				my $sign2;
				my $sign3;
				my $sign4;
				my $fsize = 16;
				my $voffset = 3;

				open (FILE, "<".$file);
				while(<FILE>) {
					print $_;
          if (m/NOMER:\s+(.*)/) {
            $number = $1;
            print "namerihme nomer\n";
          }

					if (m/MIX:\s+(.*)/) {
						$smes = $1;
					  print "namerihme smes\n";
					}

          if (m/FSIZE:\s+(.*)/) {
            $fsize = $1;
            print "namerihme fsize\n";
          }

					if (m/LINE1:\s+(.*)/) {
#            $line1 = $1;
						$line1 = $conv->convert($1);
            print "namerihme line1\n";
          }
          if (m/LINE2:\s+(.*)/) {
#            $line2 = $1;
            $line2 = $conv->convert($1);
            print "namerihme line2\n";
          }
          if (m/LINE3:\s+(.*)/) {
#            $line3 = $1;
            $line3 = $conv->convert($1);
            print "namerihme line3\n";
          }
          if (m/SIGN1:\s+(.*)/) {
            $sign1 = $1;
            print "namerihme sign1\n";
          }
          if (m/SIGN2:\s+(.*)/) {
            $sign2 = $1;
            print "namerihme sign2\n";
          }
          if (m/SIGN3:\s+(.*)/) {
            $sign3 = $1;
            print "namerihme sign3\n";
          }
          if (m/SIGN4:\s+(.*)/) {
            $sign4 = $1;
            print "namerihme sign4\n";
          }
				}

				if ($line3 eq "") {
					$voffset = -2;
				}

				$p->newpage;
        $p->setlinewidth(0.1);
        $p->box(0, 0, 90, 60);
#        $p->line(210-121-4, 5, 210-37-4, 5);

#        $p->importepsfile( {overlap => 1}, "DEMAX_HOLOGRAMS_logo.eps", 10, 20, 30, 40);
#        qrcode(sprintf("%s", $file), 35, 100, 140);
#        barcode(sprintf("%s", $file), 10.0, 0, 120.0);
#        barcode(sprintf("%s", $checksum), 10.0, 0, 10.0);

        $p->setfont("etn_____.pfb", 64);
        $p->setcolour("black");
				if ($smes ne "1" ) {
					$p->setfont("etn_____.pfb", 64);
	        $p->text({align=>'center'}, 15, 35+2, $number);
				} else {
					$p->setfont("etn_____.pfb", 32);
					$p->text({align=>'center', rotate=>'45'}, 17, 42, "ялея");
			  }

#-rw-r--r-- 1 smooker smooker 16542 Jan 12 14:13 GHS-pictogram-acid.eps
#-rw-r--r-- 1 smooker smooker  4286 Jan 12 14:19 GHS-pictogram-bottle.eps
#-rw-r--r-- 1 smooker smooker  4560 Jan 12 14:19 GHS-pictogram-exclam.eps
#-rw-r--r-- 1 smooker smooker 20318 Jan 12 14:27 GHS-pictogram-explos.eps
#-rw-r--r-- 1 smooker smooker  4506 Jan 12 14:27 GHS-pictogram-flamme.eps
#-rw-r--r-- 1 smooker smooker  7188 Jan 12 14:28 GHS-pictogram-pollu.eps
#-rw-r--r-- 1 smooker smooker  5146 Jan 12 14:28 GHS-pictogram-rondflam.eps
#-rw-r--r-- 1 smooker smooker 20874 Jan 12 14:29 GHS-pictogram-silhouette.eps
#-rw-r--r-- 1 smooker smooker 12733 Jan 12 14:29 GHS-pictogram-skull.eps

				if ($sign1 ne "") {
  				$p->importepsfile( {overlap => 1}, "./eps3/GHS-pictogram-$sign1.eps", 3, 5, 23, 25);
				}

        if ($sign2 ne "") {
          $p->importepsfile( {overlap => 1}, "./eps3/GHS-pictogram-$sign2.eps", 3+21, 5, 23+21, 25);
        }

        if ($sign3 ne "") {
          $p->importepsfile( {overlap => 1}, "./eps3/GHS-pictogram-$sign3.eps", 3+42, 5, 23+42, 25);
        }

        if ($sign4 ne "") {
          $p->importepsfile( {overlap => 1}, "./eps3/GHS-pictogram-$sign4.eps", 3+63, 5, 23+63, 25);
        }

        $p->setfont("etn_____.pfb", $fsize);
				$p->text({align=>'left'}, 32, 48+$voffset, $line1);
				$p->text({align=>'left'}, 32, 40+$voffset, $line2);
				$p->text({align=>'left'}, 32, 32+$voffset, $line3);
				$p->line(3, 31, 87, 31);
#				$p->text({align=>'left'}, 2, 24, "ме охоюи ве ях е");
#				$p->text({align=>'left'}, 2, 16, "люийюрю хаюкн");
#        $p->text({align=>'right'}, 200, 34.5, "Box No: ".sprintf("%04d", $kashon++));
#        $p->text({align=>'right'}, 115, 24.5, "End: ".sprintf("%s", $end));
#        $p->setfont("arial_rounded_bold.ttf", 10);
#		$file =~ s/\.\.\/output\///g;
#        $p->text({align=>'right'}, 200, 5.5,"Filename: ".$file);
#        $p->text({align=>'left'}, 10, 5.5, "Checksum: ".$checksum);
#		if ($kashon > 13) {
#			last;
#		}
}

$p->output("spisak.ps");

exit();
