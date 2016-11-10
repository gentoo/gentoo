# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=4.81
inherit perl-module

DESCRIPTION="Validates user input (usually from an HTML form) based on input profile"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="dev-perl/Image-Size
	>=dev-perl/Date-Calc-5.0
	>=dev-perl/File-MMagic-1.17
	>=dev-perl/MIME-Types-1.005
	dev-perl/Regexp-Common
	>=dev-perl/Perl6-Junction-1.10
	dev-perl/Email-Valid"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
