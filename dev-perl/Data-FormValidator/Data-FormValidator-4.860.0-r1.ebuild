# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DFARRELL
DIST_VERSION=4.86
inherit perl-module

DESCRIPTION="Validates user input (usually from an HTML form) based on input profile"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/4.86-dot-in-inc.patch" )
RDEPEND="dev-perl/Image-Size
	>=dev-perl/Date-Calc-5.0
	>=dev-perl/File-MMagic-1.17
	>=dev-perl/MIME-Types-1.005
	>=dev-perl/Regexp-Common-0.30.0
	dev-perl/Email-Valid
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
