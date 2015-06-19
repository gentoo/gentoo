# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libqzeitgeist/libqzeitgeist-0.8.0.ebuild,v 1.7 2015/05/13 18:34:31 kensington Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
KDE_REQUIRED="never"
inherit python-any-r1 kde4-base

DESCRIPTION="Qt interface to the Zeitgeist event tracking system"
HOMEPAGE="https://projects.kde.org/projects/kdesupport/libqzeitgeist"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="4"
IUSE="debug"

RDEPEND="
	dev-libs/libzeitgeist
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtdeclarative:4
"
DEPEND="${RDEPEND}
	$(python_gen_any_dep 'gnome-extra/zeitgeist[${PYTHON_USEDEP}]')
	gnome-extra/zeitgeist
"

python_check_deps() {
	has_version "gnome-extra/zeitgeist[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	kde4-base_pkg_setup
}

src_prepare() {
	sed -e "/^find_package(Qt4/s/QtTest//" -i CMakeLists.txt || die

	kde4-base_src_prepare
}
