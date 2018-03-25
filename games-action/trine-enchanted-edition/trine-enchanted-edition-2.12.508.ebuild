# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils gnome2-utils

MY_P="${PV//./_}"
MY_P="${PN//-/_}_v${MY_P%_*}_build_${MY_P##*_}"
MY_PN="Trine Enchanted Edition"

DESCRIPTION="The original sidescrolling action platformer under the Trine 2 engine"
HOMEPAGE="https://www.frozenbyte.com/games/trine-enchanted-edition"
SRC_URI="${MY_P}_humble_linux_full.zip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+launcher"
RESTRICT="bindist fetch splitdebug"

QA_PREBUILT="opt/${PN}/${PN}*"

DEPEND="app-arch/unzip"

# SDL 1.3 is bundled but the game appears to be statically linked
# against SDL 2.0.3. This is unfortunate as there are bugs. For example,
# it doesn't respect the DISPLAY variable under Zaphod mode.

RDEPEND="
	media-gfx/nvidia-cg-toolkit[abi_x86_32]
	media-libs/alsa-lib[abi_x86_32]
	media-libs/freetype:2[abi_x86_32]
	media-libs/libogg[abi_x86_32]
	>=media-libs/libvorbis-1.3[abi_x86_32]
	>=media-libs/openal-1.15[abi_x86_32]
	sys-libs/zlib[abi_x86_32]
	virtual/glu[abi_x86_32]
	virtual/opengl[abi_x86_32]
	launcher? (
		dev-libs/glib:2[abi_x86_32]
		media-libs/libpng:1.2[abi_x86_32]
		x11-libs/gdk-pixbuf:2[abi_x86_32,X]
		x11-libs/gtk+:2[abi_x86_32]
		x11-libs/libX11[abi_x86_32]
		x11-libs/pango[abi_x86_32,X]
	)"

S="${WORKDIR}/linux/_enchanted_edition_"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	local dir=/opt/${PN}

	insinto "${dir}"
	doins -r *.fbq data

	exeinto "${dir}"
	newexe bin/trine1_linux_32bit ${PN}

	make_wrapper ${PN} ./${PN} "${dir}"
	make_desktop_entry ${PN} "${MY_PN}"

	if use launcher ; then
		exeinto "${dir}"
		newexe bin/trine1_linux_launcher_32bit ${PN}-launcher

		make_wrapper ${PN}-launcher ./${PN}-launcher "${dir}"
		make_desktop_entry ${PN}-launcher "${MY_PN} (launcher)"

		# Launcher binary has hardcoded the game path.
		dosym ../${PN} "${dir}"/bin/trine1_bin_starter.sh
	fi

	newicon -s 64 trine1.png ${PN}.png
	dodoc readme_changelog.txt
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
