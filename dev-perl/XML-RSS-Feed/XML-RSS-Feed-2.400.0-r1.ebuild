# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JBISBEE
MODULE_VERSION=2.4
inherit perl-module

DESCRIPTION="Persistant XML RSS Encapsulation"
SRC_URI+="  https://dev.gentoo.org/~tove/distfiles/dev-perl/XML-RSS-Feed/XML-RSS-Feed-2.320.0-patch.tar.bz2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

EPATCH_SUFFIX=patch
PATCHES=(
	"${WORKDIR}"/${MY_PN:-${PN}}-patch
)

RDEPEND="dev-perl/HTML-Parser
	dev-perl/XML-RSS
	dev-perl/Clone
	virtual/perl-Time-HiRes
	dev-perl/URI
	virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
