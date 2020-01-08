# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop eutils gnome2-utils

MY_P="${PV//./_}"
MY_P="${PN}_complete_story_v${MY_P%_*}_build_${MY_P##*_}"
MY_PN="Trine 2"

DESCRIPTION="Sidescrolling game of action, puzzles and platforming, Complete Story edition"
HOMEPAGE="http://www.trine2.com/"
SRC_URI="${MY_P}_humble_linux_full.zip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+launcher"
RESTRICT="bindist fetch splitdebug"

QA_PREBUILT="opt/${PN}/${PN}*
	opt/${PN}/lib/*"

DEPEND="app-arch/unzip"

RDEPEND="
	media-gfx/nvidia-cg-toolkit[abi_x86_32]
	media-libs/alsa-lib[abi_x86_32]
	media-libs/freetype:2[abi_x86_32]
	media-libs/libogg[abi_x86_32]
	>=media-libs/libvorbis-1.3[abi_x86_32]
	>=media-libs/openal-1.15[abi_x86_32]
	>=sys-devel/gcc-4.6[cxx]
	>=sys-libs/glibc-2.15
	sys-libs/zlib[abi_x86_32]
	virtual/glu[abi_x86_32]
	virtual/opengl[abi_x86_32]
	launcher? (
		dev-libs/expat[abi_x86_32]
		dev-libs/glib:2[abi_x86_32]
		media-libs/libpng-compat:1.2[abi_x86_32]
		sys-apps/dbus[abi_x86_32]
		sys-apps/util-linux[abi_x86_32]
		x11-libs/gdk-pixbuf:2[abi_x86_32,X]
		x11-libs/gtk+:2[abi_x86_32]
		x11-libs/libX11[abi_x86_32]
		x11-libs/pango[abi_x86_32,X]
	)"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/trine-2-complete-story"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default

	# SDL 1.3 is very special and crashes when fullscreen if
	# /usr/bin/gnome-screensaver-command is missing. XD
	sed -i 's:/usr/bin/gnome-screensaver-command:/bin/true\x0                        :g' \
		lib/lib32/libSDL-1.3.so.0 || die
}

src_install() {
	local dir=/opt/${PN}

	insinto "${dir}"
	doins -r *.fbq data

	exeinto "${dir}"
	newexe bin/${PN}_linux_32bit ${PN}

	exeinto "${dir}"/lib
	doexe lib/lib32/lib{{SDL-1.3,PhysXLoader}.so.*,PhysX{Cooking,Core}.so} # Avoid duplicates.

	make_wrapper ${PN} ./${PN} "${dir}" "${dir}"/lib
	make_desktop_entry ${PN} "${MY_PN}"

	if use launcher ; then
		exeinto "${dir}"
		newexe bin/${PN}_linux_launcher_32bit ${PN}-launcher

		make_wrapper ${PN}-launcher ./${PN}-launcher "${dir}" "${dir}"/lib
		make_desktop_entry ${PN}-launcher "${MY_PN} (launcher)"

		# Launcher binary has hardcoded the game path.
		dosym ../${PN} "${dir}"/bin/${PN}_bin_starter.sh
	fi

	doicon -s 64 ${PN}.png
	dodoc readme_changelog.txt readme/{KNOWN_LINUX_ISSUES,README}
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
