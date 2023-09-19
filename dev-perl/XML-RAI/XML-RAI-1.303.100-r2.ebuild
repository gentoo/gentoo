# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMA
DIST_VERSION=1.3031
inherit perl-module

DESCRIPTION="RSS Abstraction Interface"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-perl/TimeDate-1.16
	dev-perl/XML-Elemental
	>=dev-perl/XML-RSS-Parser-4
	dev-perl/Class-XPath"
BDEPEND="${RDEPEND}
"

src_prepare() {
	sed -i "/^require Task::Weaken/d" "${S}"/Makefile.PL || die
	perl-module_src_prepare
}
