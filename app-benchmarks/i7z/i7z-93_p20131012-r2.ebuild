# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic qmake-utils toolchain-funcs

COMMIT="5023138d7c35c4667c938b853e5ea89737334e92"
DESCRIPTION="A better i7 (and now i3, i5) reporting tool for Linux"
HOMEPAGE="https://github.com/ajaiantilal/i7z"
SRC_URI="https://github.com/ajaiantilal/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="qt5"

RDEPEND="
	sys-libs/ncurses:0=
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/i7z-0.27.2-ncurses.patch
	"${FILESDIR}"/qt5.patch
	"${FILESDIR}"/gcc5.patch

	# From Debian
	"${FILESDIR}"/fix-insecure-tempfile.patch
	"${FILESDIR}"/fix_cpuid_asm.patch
	"${FILESDIR}"/hyphen-used-as-minus-sign.patch
	"${FILESDIR}"/install-i7z_rw_registers.patch
	"${FILESDIR}"/use_stdbool.patch
	"${FILESDIR}"/nehalem.patch
	"${FILESDIR}"/gcc-10.patch
	"${FILESDIR}"/typos.patch
)

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	tc-export CC PKG_CONFIG
	cd GUI || die
	use qt5 && eqmake5 ${PN}_GUI.pro
}

src_compile() {
	default

	if use qt5; then
		emake -C GUI clean
		emake -C GUI
	fi
}

src_install() {
	emake DESTDIR="${ED}" docdir=/usr/share/doc/${PF} install

	if use qt5; then
		dosbin GUI/i7z_GUI
	fi
}
