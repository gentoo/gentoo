# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Exception-Base/Exception-Base-0.250-r1.ebuild,v 1.2 2015/06/13 21:49:28 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Error handling with exception class"

SLOT="0"
KEYWORDS="~amd64 ~x86"
# Package warrants IUSE examples
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( >=dev-perl/Test-Unit-Lite-0.12 )"

SRC_TEST="do"

src_install(){
	perl-module_src_install
	docompress -x usr/share/doc/${PF}/examples
	insinto usr/share/doc/${PF}/
	doins -r examples/
}
