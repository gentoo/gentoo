# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Small, lightweight Qt text editor"
HOMEPAGE="https://tea.ourproject.org/"
SRC_URI="https://tea.ourproject.org/dloads/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aspell djvu hunspell pdf +qml"

BDEPEND="
	hunspell? ( virtual/pkgconfig )
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	aspell? ( app-text/aspell )
	djvu? ( app-text/djvu )
	hunspell? ( app-text/hunspell:= )
	pdf? ( app-text/poppler[qt5] )
	qml? ( dev-qt/qtdeclarative:5 )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS NEWS-RU TODO )

src_configure() {
	local myqmakeargs=(
		PREFIX=/usr
		$(usex aspell '' CONFIG+=noaspell)
		$(usex djvu CONFIG+=usedjvu '')
		$(usex hunspell '' CONFIG+=nohunspell)
		$(usex pdf CONFIG+=usepoppler '')
		$(usex qml '' CONFIG+=noqml)
	)
	eqmake5 tea-qmake.pro "${myqmakeargs[@]}"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs

	docinto html
	dodoc manuals/*.html

	insinto /usr/share/qt5/translations
	doins translations/${PN}_*.qm
}
