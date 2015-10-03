# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=AIZVORSKI
inherit perl-module

DESCRIPTION="convert between color spaces"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
# Pacakge warrants IUSE examples"
IUSE=""

COMMON_DEPEND="
	>=dev-perl/Graphics-ColorNames-0.32
"
DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"

src_install() {
	perl-module_src_install
	docompress -x usr/share/doc/${PF}/examples/
	insinto usr/share/doc/${PF}/
	doins -r examples
}
