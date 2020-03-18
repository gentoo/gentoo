# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs gnome2-utils

MY_PN=defcon
MY_PV=${PV:0:3}
MY_PVR=1
MY_P=defcon_${MY_PV}-${MY_PVR}

DESCRIPTION="Global thermonuclear war simulation with multiplayer support"
HOMEPAGE="http://www.introversion.co.uk/defcon/"
SRC_URI="x86? ( http://www.introversion.co.uk/defcon/downloads/${MY_P}_i386.deb )
	amd64? ( http://www.introversion.co.uk/defcon/downloads/${MY_P}_amd64.deb )"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+system-libs"
RESTRICT="bindist mirror strip"

# glibc discussion:
# http://forums.introversion.co.uk/defcon/viewtopic.php?t=4016
RDEPEND="
	media-libs/libogg
	media-libs/libvorbis
	>=sys-libs/glibc-2.3
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	system-libs? ( media-libs/libsdl[sound,video] )"
DEPEND=""

QA_PREBUILT="/opt/${PN}/lib/${MY_PN}.bin.x86"

S="${WORKDIR}/usr/local/games/${MY_PN}"

src_unpack() {
	default
	unpack ./data.tar.gz

	cd "${S}" || die
	# maintain compatibility with old installation/script
	[[ -e lib64 ]] && { mv lib64 lib || die ;}
	[[ -e ${MY_PN}.bin.x86_64 ]] && { mv ${MY_PN}.bin.x86_64 ${MY_PN}.bin.x86 || die ;}
}

src_prepare() {
	default

	# FindPath scripts are ugly and unnecessary
	if use system-libs ; then
		rm -f lib/lib*
	fi
	sed \
		-e "s:GAMEDIR:/opt/${PN}:g" \
		"${FILESDIR}"/${MY_PN} > "${T}"/${MY_PN} || die
	echo "int chdir(const char *d) { return 0; }" > chdir.c || die
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -shared -o lib/chdir.so chdir.c"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -fPIC -shared -o lib/chdir.so chdir.c || die
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}/lib"
	doins *.dat

	exeinto "${dir}"/lib
	doexe lib/*.so
	doexe ${MY_PN}.bin.x86

	doicon -s 128 ${MY_PN}.png

	# Can be upgraded to full version, so is not installed as "demo"
	dobin "${T}"/${MY_PN}
	make_desktop_entry ${MY_PN} "Defcon"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "Screenshots will appear in ~/.${MY_PN}/lib"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
