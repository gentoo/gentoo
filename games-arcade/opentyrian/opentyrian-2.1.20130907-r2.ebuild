# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs xdg-utils

DESCRIPTION="Open-source port of the DOS game Tyrian, vertical scrolling shooter"
HOMEPAGE="https://github.com/opentyrian/opentyrian"
SRC_URI="http://darklomax.org/tyrian/tyrian21.zip
	http://www.camanis.net/${PN}/releases/${P}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-net"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${PV}-datapath.diff"
	"${FILESDIR}/${PV}-cflag-idiocy.diff"
	"${FILESDIR}/${PV}-gcc10.patch"
)

src_prepare() {
	default
	rm "${WORKDIR}"/tyrian21/{*.exe,dpmi16bi.ovl,loudness.awe} || die "Failed to remove win32 binaries"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		DATA_PATH="${EPREFIX}/usr/share/${PN}"
}

src_install() {
	dobin opentyrian
	dosym opentyrian /usr/bin/tyrian
	dodoc CREDITS NEWS README
	domenu linux/opentyrian.desktop

	local size
	for i in linux/icons/*.png ; do
		size=${i%.png}
		size=${size##*-}
		newicon -s "${size}" "${i}" opentyrian.png
	done

	insinto /usr/share/"${PN}"
	doins "${WORKDIR}"/tyrian21/*
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
