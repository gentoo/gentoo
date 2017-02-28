# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DEXTER
DIST_VERSION=0.2501
inherit perl-module

DESCRIPTION="Error handling with exception class"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( >=dev-perl/Test-Unit-Lite-0.120.0 )
"

src_install(){
	perl-module_src_install
	docompress -x usr/share/doc/${PF}/examples
	insinto usr/share/doc/${PF}/
	doins -r examples/
}
