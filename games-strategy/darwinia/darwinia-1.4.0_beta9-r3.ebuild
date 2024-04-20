# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CDROM_OPTIONAL="yes"
inherit cdrom desktop unpacker wrapper

MY_PV=${PV/_beta/b}
DESCRIPTION="The hyped indie game of the year - by the Uplink creators"
HOMEPAGE="http://www.darwinia.co.uk/support/linux.html"
SRC_URI="http://www.introversion.co.uk/darwinia/downloads/${PN}-full-${MY_PV}.sh"
S="${WORKDIR}"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"

RDEPEND="
	media-libs/libsdl[abi_x86_32(-)]
	media-libs/libvorbis[abi_x86_32(-)]
	sys-libs/glibc
	sys-libs/libstdc++-v3:5
	virtual/glu[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"

dir=/opt/${PN}
QA_PREBUILT="${dir#1}/lib/darwinia.bin.x86"

src_unpack() {
	use cdinstall && cdrom_get_cds gamefiles/main.dat
	unpack_makeself
}

src_install() {
	insinto "${dir}"/lib
	exeinto "${dir}"/lib

	doins lib/{language,patch}.dat
	doexe lib/darwinia.bin.x86 lib/open-www.sh

	exeinto "${dir}"
	doexe bin/Linux/x86/darwinia

	if use cdinstall ; then
		doins "${CDROM_ROOT}"/gamefiles/{main,sounds}.dat
	fi

	dodoc README
	newicon darwinian.png darwinia.png

	make_wrapper darwinia ./darwinia "${dir}" "${dir}"
	make_desktop_entry darwinia "Darwinia"
}

pkg_postinst() {
	if ! use cdinstall; then
		ewarn "To play the game, you need to copy main.dat and sounds.dat"
		ewarn "from gamefiles/ on the game CD to ${dir}/lib/."
	fi
}
