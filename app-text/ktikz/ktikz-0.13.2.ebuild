# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg optfeature

DESCRIPTION="editor for the TikZ drawing language"
HOMEPAGE="https://github.com/fhackenberger/ktikz"
SRC_URI="
	https://github.com/fhackenberger/ktikz/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	app-text/poppler[qt5]
"
RDEPEND="${DEPEND}
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-pictures
"
BDEPEND="
	dev-qt/linguist-tools:5
	dev-qt/qthelp:5
"

src_configure() {
	local myqmakeargs=(
		PREFIX=/usr
		QMAKECOMMAND="$(qt5_get_bindir)/qmake"
		LRELEASECOMMAND="$(qt5_get_bindir)/lrelease"
		QCOLLECTIONGENERATORCOMMAND="$(qt5_get_bindir)/qcollectiongenerator"
	)
	eqmake5 qtikz.pro "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	local DOCS=( README.md )
	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "viewing documentation" dev-qt/assistant:5
}
