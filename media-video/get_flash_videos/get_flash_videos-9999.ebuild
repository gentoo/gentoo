# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/get_flash_videos/get_flash_videos-9999.ebuild,v 1.4 2014/07/29 19:20:29 dilfridge Exp $

EAPI=5
inherit eutils perl-module git-2

MY_PN="App-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Downloads videos from various Flash-based video hosting sites"
HOMEPAGE="http://code.google.com/p/get-flash-videos/"
EGIT_REPO_URI="git://github.com/monsieurvideo/get-flash-videos.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="dev-perl/WWW-Mechanize
	virtual/perl-Module-CoreList
	dev-perl/HTML-TokeParser-Simple
	dev-perl/Module-Find"
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
	perl-module_src_prepare
}

pkg_postinst() {
	elog "Downloading videos from RTMP server requires the following packages :"
	elog "	media-video/rtmpdump"
	elog "	dev-perl/Tie-IxHash"
	elog "Others optional dependencies :"
	elog "	dev-perl/XML-Simple"
	elog "	dev-perl/Crypt-Rijndael"
	elog "	dev-perl/Data-AMF"
	elog "	virtual/perl-IO-Compress"
}
