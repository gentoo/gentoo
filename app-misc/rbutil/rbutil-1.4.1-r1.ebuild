# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="https://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	dev-libs/crypto++:=
	dev-libs/quazip:0
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/speex
	media-libs/speexdsp
	virtual/libusb:1
"

DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

S="${WORKDIR}/RockboxUtility-v${PV}"
QTDIR="${PN}/${PN}qt"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-quazip.patch
	"${FILESDIR}"/0001-imxtools-sbtools-fix-compilation-with-gcc-10.patch
)

src_prepare() {
	xdg_src_prepare
	rm -rv "${QTDIR}"/{quazip,zlib}/ || die
}

src_configure() {
	cd "${QTDIR}" || die

	# Generate binary translations.
	"$(qt5_get_bindir)"/lrelease ${PN}qt.pro || die

	# noccache is required to call the correct compiler.
	eqmake5 CONFIG+="noccache $(use debug && echo dbg)"
}

src_compile() {
	emake -C "${QTDIR}"
}

src_install() {
	cd "${QTDIR}" || die

	local icon size
	for icon in icons/rockbox-*.png; do
		size=${icon##*-}
		size=${size%%.*}
		newicon -s "${size}" "${icon}" rockbox.png
	done

	dobin RockboxUtility
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox
	dodoc changelog.txt
}
