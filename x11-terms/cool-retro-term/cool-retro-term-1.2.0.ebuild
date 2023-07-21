# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

QTW_PN="qmltermwidget"
QTW_PV=63228027e1f97c24abb907550b22ee91836929c5
QTW_P="${QTW_PN}-${QTW_PV}"

DESCRIPTION="Terminal emulator with an old school look and feel"
HOMEPAGE="https://github.com/Swordfish90/cool-retro-term/"

SRC_URI="
	https://github.com/Swordfish90/cool-retro-term/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Swordfish90/qmltermwidget/archive/${QTW_PV}.tar.gz -> ${QTW_P}.tar.gz
"

LICENSE="BSD GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols:5[widgets]
	dev-qt/qtquickcontrols2:5[widgets]
	dev-qt/qtwidgets:5
"

RDEPEND="${DEPEND}
	virtual/opengl"

src_prepare() {
	default

	rmdir "${QTW_PN}" || die
	mv "${WORKDIR}/${QTW_P}" "${QTW_PN}" || die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	# `default` attempts to install directly to /usr and parallelised
	# installation is not supported as `qmake5 -install` does not implictly
	# create target directory.

	emake -j1 INSTALL_ROOT="${ED}" install
	doman "packaging/debian/cool-retro-term.1"

	insinto "/usr/share/metainfo"
	doins "packaging/appdata/cool-retro-term.appdata.xml"
}
