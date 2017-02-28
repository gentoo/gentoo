# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# This appears it should really be entitled Audio-CD
# There are * QA Notice: errors on building however the HOMEPAGE gives no source repo in which to file
# prob. not worth the trouble for this little script.

EAPI=5
inherit perl-module

MY_P=Audio-CD-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl Module needed for app-cdr/disc-cover"
HOMEPAGE="http://www.vanhemert.co.uk/disc-cover.html"
SRC_URI="http://www.vanhemert.co.uk/files/${MY_P}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"

DEPEND=">=dev-perl/URI-1.10
	>=dev-perl/HTML-Parser-3.15
	>=virtual/perl-MIME-Base64-2.12
	>=virtual/perl-Digest-MD5-2.12
	>=virtual/perl-libnet-1.0703-r1
	>=dev-perl/libwww-perl-5.50
	>=media-libs/libcdaudio-0.99.6"
