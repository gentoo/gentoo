# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/telepathy-logger-qt/telepathy-logger-qt-0.8.0.ebuild,v 1.3 2015/04/08 18:04:58 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
KDE_REQUIRED="never"
inherit kde4-base python-any-r1

DESCRIPTION="Qt4 bindings for the Telepathy logger"
HOMEPAGE="https://projects.kde.org/projects/extragear/network/telepathy/telepathy-logger-qt"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

RDEPEND="
	media-libs/qt-gstreamer[qt4(+)]
	>=net-im/telepathy-logger-0.8.0
	net-libs/telepathy-glib
	>=net-libs/telepathy-qt-0.9.1
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	sys-devel/bison
	sys-devel/flex
"

pkg_setup() {
	python-any-r1_pkg_setup
	kde4-base_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)
	kde4-base_src_configure
}
