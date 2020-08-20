# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

DESCRIPTION="Open-source port of the DOS game Tyrian, vertical scrolling shooter"
HOMEPAGE="https://github.com/opentyrian/opentyrian"
SRC_URI="http://darklomax.org/tyrian/tyrian21.zip
	http://www.camanis.net/${PN}/releases/${P}-src.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl
	media-libs/sdl-net"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${PV}-datapath.diff"
	"${FILESDIR}/${PV}-cflag-idiocy.diff"
	"${FILESDIR}/${PV}-gcc10.patch"
)

src_compile() {
	emake DATA_PATH="/usr/share/${PN}"
}

src_install() {
	dobin opentyrian
	dosym ../../usr/bin/opentyrian /usr/bin/tyrian
	dodoc CREDITS NEWS README
	domenu linux/opentyrian.desktop || die "Failed to install desktop file"
	for i in linux/icons/*.png ; do
		local size=`echo ${i} | sed -e 's:.*-\([0-9]\+\).png:\1:'`
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		newins ${i} opentyrian.png
	done
	insinto "/usr/share/${PN}"
	cd "${WORKDIR}/tyrian21"
	rm *.exe dpmi16bi.ovl loudness.awe || die "Failed to remove win32 binaries"
	doins *
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
