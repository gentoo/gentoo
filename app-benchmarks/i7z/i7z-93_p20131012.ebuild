# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils toolchain-funcs

COMMIT="5023138d7c35c4667c938b853e5ea89737334e92"
DESCRIPTION="A better i7 (and now i3, i5) reporting tool for Linux"
HOMEPAGE="https://github.com/ajaiantilal/i7z"
SRC_URI="https://github.com/ajaiantilal/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="qt4 qt5"

RDEPEND="sys-libs/ncurses:0=
	qt5? (
		dev-qt/qtcore:5=
		dev-qt/qtgui:5=
		dev-qt/qtwidgets:5=
	)
	!qt5? ( qt4? (
		dev-qt/qtcore:4=
		dev-qt/qtgui:4=
	) )"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/i7z-0.27.2-ncurses.patch
	"${FILESDIR}"/qt5.patch
	"${FILESDIR}"/gcc5.patch
)

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	# The GUI segfaults with -O1. None of the documented flags make a
	# difference. There may not be a specific flag for the culprit.
	filter-flags "-O*"

	tc-export CC
	cd GUI || die

	if use qt5; then
		eqmake5 ${PN}_GUI.pro
	elif use qt4; then
		eqmake4 ${PN}_GUI.pro
	fi
}

src_compile() {
	default

	if use qt5 || use qt4; then
		emake -C GUI clean
		emake -C GUI
	fi
}

src_install() {
	emake DESTDIR="${ED}" docdir=/usr/share/doc/${PF} install

	if use qt5 || use qt4; then
		dosbin GUI/i7z_GUI
	fi
}
