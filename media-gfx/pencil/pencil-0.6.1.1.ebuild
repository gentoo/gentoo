# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop qmake-utils xdg-utils

DESCRIPTION="2D animation and drawing program based on Qt5"
HOMEPAGE="https://www.pencil2d.org/"
SRC_URI="https://github.com/pencil2d/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	default
	sed -e "/^QT/s/xmlpatterns //" \
		-i core_lib/core_lib.pro tests/tests.pro || die
}

src_configure() {
	eqmake5
}

src_install() {
	einstalldocs

	# install target not yet provided
	# emake INSTALL_ROOT="${D}" install
	newbin bin/pencil2d ${PN}

	newicon app/data/icons/icon.png ${PN}.png
	make_desktop_entry ${PN} pencil2d ${PN} Graphics

	insinto /usr/share/mime/packages/
	doins app/data/pencil2d.xml

	# TODO: Install l10n files
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
