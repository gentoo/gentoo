# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils perl-module readme.gentoo

MY_PN="App-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Downloads videos from various Flash-based video hosting sites"
HOMEPAGE="http://code.google.com/p/get-flash-videos/"
SRC_URI="http://get-flash-videos.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="test"

RDEPEND="dev-perl/WWW-Mechanize
	virtual/perl-Module-CoreList
	dev-perl/HTML-TokeParser-Simple"
DEPEND="${RDEPEND}
	dev-perl/UNIVERSAL-require
	test? ( media-video/rtmpdump
		dev-perl/Tie-IxHash
		dev-perl/XML-Simple
		dev-perl/Crypt-Rijndael
		dev-perl/Data-AMF
		virtual/perl-IO-Compress )"

SRC_TEST="do"

S="${WORKDIR}/${MY_P}"
SRC_TEST="do"
myinst="DESTDIR=${D}"

src_prepare() {
	DISABLE_AUTOFORMATTING="yes"
	DOC_CONTENTS="Downloading videos from RTMP server requires the following packages:
- media-video/rtmpdump
- dev-perl/Tie-IxHash
Other optional dependencies:
- dev-perl/XML-Simple
- dev-perl/Crypt-Rijndael
- dev-perl/Data-AMF
- virtual/perl-IO-Compress"

	# 405761
	epatch "${FILESDIR}"/${PN}-youtubefix.patch
	perl-module_src_prepare
}

src_install() {
	perl-module_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
