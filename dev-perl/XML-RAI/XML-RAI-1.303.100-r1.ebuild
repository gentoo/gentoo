# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-RAI/XML-RAI-1.303.100-r1.ebuild,v 1.3 2014/08/05 11:32:55 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TIMA
MODULE_VERSION=1.3031
inherit perl-module

DESCRIPTION="RSS Abstraction Interface"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_TEST="do parallel"

DEPEND=">=dev-perl/TimeDate-1.16
	dev-perl/XML-Elemental
	>=dev-perl/XML-RSS-Parser-4
	dev-perl/Class-XPath"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "/^require Task::Weaken/d" "${S}"/Makefile.PL || die
	perl-module_src_prepare
}
