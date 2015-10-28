# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=XAOC
MODULE_VERSION=1.224
inherit perl-module

DESCRIPTION="Layout and render international text"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-perl/glib-perl-1.220.0
	>=dev-perl/Cairo-1.0.0
	>=x11-libs/pango-1.0.0
"
DEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.300.0
	>=dev-perl/extutils-pkgconfig-1.30.0
"

PATCHES=(
	"${FILESDIR}"/"${P}-linking.patch"
)

src_prepare() {
	perl-module_src_prepare
	sed -i -e "s:exit 0:exit 1:g" "${S}"/Makefile.PL || die "sed failed"
}
