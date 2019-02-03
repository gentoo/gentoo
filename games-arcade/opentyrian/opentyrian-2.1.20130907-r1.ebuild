# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils

DESCRIPTION="Open-source port of the DOS game Tyrian, vertical scrolling shooter"
HOMEPAGE="https://bitbucket.org/opentyrian/opentyrian/wiki/Home"
SRC_URI="http://darklomax.org/tyrian/tyrian21.zip
	 http://www.camanis.net/${PN}/releases/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-net"

# Yes, mercurial is needed to set the build version stamp.
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-vcs/mercurial"

PATCHES=(
	"${FILESDIR}/${PV}-datapath.diff"
	"${FILESDIR}/${PV}-cflag-idiocy.diff"
)

src_compile() {
	emake DATA_PATH="/usr/share/${PN}" || die "Compilation failed"
}

src_install() {
	dobin opentyrian || die "Failed to install game binary"
	dosym ../../usr/bin/opentyrian /usr/bin/tyrian || die "Failed to symlink"
	dodoc CREDITS NEWS README || die "Failed to install documentation"
	domenu linux/opentyrian.desktop || die "Failed to install desktop file"
	for i in linux/icons/*.png ; do
		local size=`echo ${i} | sed -e 's:.*-\([0-9]\+\).png:\1:'`
		insinto /usr/share/icons/hicolor/${size}x${size}/apps
		newins ${i} opentyrian.png || die "Failed to install program icon"
	done
	insinto "/usr/share/${PN}"
	cd "${WORKDIR}/tyrian21"
	rm *.exe dpmi16bi.ovl loudness.awe || die "Failed to remove win32 binaries"
	doins * || die "Failed to install game data"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
