# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg-utils

DESCRIPTION="2D animation and drawing program based on Qt5"
HOMEPAGE="https://www.pencil2d.org/"
SRC_URI="https://github.com/pencil2d/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/pencil2d/pencil/617c8868fd27ce540de285ff75c8946fba0c975b/tests/src/catch.hpp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	cp "${DISTDIR}"/catch.hpp tests/src/
	default
	sed -e "/^QT/s/xmlpatterns //" \
		-i core_lib/core_lib.pro tests/tests.pro || die
}

src_configure() {
	eqmake5 PREFIX=/usr $(usex test "" "CONFIG+=NO_TESTS")
}

src_install() {
	einstalldocs
	emake INSTALL_ROOT="${D}" install
	# TODO: Install l10n files
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
