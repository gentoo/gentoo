# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.25
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

SRC_TEST="do parallel"

PATCHES=(
	"${FILESDIR}/${P}-sprintf.patch"
)

src_install(){
	perl-module_src_install
	docompress -x usr/share/doc/${PF}/examples
	insinto usr/share/doc/${PF}/
	doins -r examples/
}
