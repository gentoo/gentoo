# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper xdg

DESCRIPTION="Physics-based action game with character-dependent solutions to challenges"
HOMEPAGE="https://www.frozenbyte.com/games/trine-enchanted-edition"
SRC_URI="TrineUpdate4.64.run"
LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+launcher"
RESTRICT="bindist fetch strip"

QA_PREBUILT="opt/${PN}/${PN}*
	opt/${PN}/lib/*"

BDEPEND="
	app-admin/chrpath
	app-arch/unzip
"

RDEPEND="
	media-gfx/nvidia-cg-toolkit
	>=media-libs/libsdl-1.2[opengl,video]
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-ttf-2.0
	>=media-libs/libvorbis-1.3
	>=media-libs/openal-1.15
	>=sys-devel/gcc-4.3.0
	>=sys-libs/glibc-2.4
	sys-libs/zlib
	x11-libs/gtk+:2
	launcher? (
		dev-libs/glib:2
		gnome-base/libglade:2.0
	)"

S="${WORKDIR}"
dir="/opt/${PN}"

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into your distfiles directory."
	einfo "It is no longer available to purchase but you can still download it"
	einfo "from https://www.humblebundle.com if you bought it previously."
	einfo "Otherwise install ${CATEGORY}/trine-enchanted-edition instead."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default
	use launcher || rm -v lib*/lib{boost*,icu*}.* || die
	rm -v lib*/lib{Cg*,direct*,fusion*,gcc_s,jpeg,m,ogg,openal,png*,rt,SDL*,selinux,stdc++,tiff,vga,vorbis*}.* || die
	chrpath --replace "${EPREFIX}${dir}"/lib trine-{bin,launcher}$(usex x86 32 64) || die
}

src_install() {
	local sfx=$(usex x86 32 64)

	insinto "${dir}"
	doins -r binds config data dev profiles *.fbz *.glade trine-logo.png

	exeinto "${dir}/lib"
	doexe lib${sfx}/*

	exeinto "${dir}"
	newexe trine-bin${sfx} ${PN}

	make_wrapper ${PN} ./${PN} "${dir}"
	make_desktop_entry ${PN} "Trine"

	# Compatibility with trine-bin.
	dosym ${PN} /usr/bin/${PN}-bin

	if use launcher ; then
		exeinto "${dir}"
		newexe trine-launcher${sfx} ${PN}-launcher

		dosym {"../..${dir}",/usr/bin}/${PN}-launcher
		make_desktop_entry ${PN}-launcher "Trine (launcher)"

		# Launcher binary has hardcoded the game path.
		dosym ${PN} "${dir}"/${PN}-bin
	fi

	newicon -s 512 Trine.xpm ${PN}.xpm
	dodoc Trine_Manual_linux.pdf Trine_updates.txt
}
