# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit perl-module readme.gentoo-r1

DESCRIPTION="Downloads videos from various Flash-based video hosting sites"
HOMEPAGE="https://github.com/monsieurvideo/get-flash-videos"
SRC_URI="https://github.com/monsieurvideo/get-flash-videos/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
#RESTRICT="test" # Fail to work for a long time, bug #407381

RDEPEND="
	dev-perl/HTML-TokeParser-Simple
	dev-perl/Module-Find
	dev-perl/Term-ProgressBar
	dev-perl/WWW-Mechanize
	virtual/perl-Module-CoreList
"
DEPEND="${RDEPEND}
	dev-perl/UNIVERSAL-require
	test? ( media-video/rtmpdump
		dev-perl/Tie-IxHash
		dev-perl/XML-Simple
		dev-perl/Crypt-Rijndael
		dev-perl/Data-AMF
		virtual/perl-IO-Compress )
"

S="${WORKDIR}/${P//_/-}"

SRC_TEST="do"
myinst="DESTDIR=${D}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Downloading videos from RTMP server requires the following packages:
- media-video/rtmpdump
- dev-perl/Tie-IxHash
Other optional dependencies:
- dev-perl/XML-Simple
- dev-perl/Crypt-Rijndael
- dev-perl/Data-AMF
- virtual/perl-IO-Compress"

src_install() {
	perl-module_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
