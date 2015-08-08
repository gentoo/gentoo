# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cdrom eutils games unpacker

MY_PN="ssamtfe"

DESCRIPTION="Serious Sam: The First Encounter"
HOMEPAGE="http://www.croteam.com/
	http://www.seriouszone.com/
	http://icculus.org/betas/ssam/"
SRC_URI="http://icculus.org/betas/ssam/ssam-tfe-lnx-beta1a.run
	http://icculus.org/updates/ssam/${MY_PN}-beta1b.sh.bin
	http://icculus.org/updates/ssam/${MY_PN}-beta2.sh.bin
	http://icculus.org/updates/ssam/${MY_PN}-beta3.sh.bin"
LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"
IUSE="alsa"

RDEPEND="
	>=media-libs/libsdl-1.2.15-r5[X,joystick,opengl,video,abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	alsa? (
		>=media-libs/libogg-1.3.1[abi_x86_32(-)]
		>=media-libs/libsdl-1.2.15-r5[alsa,sound,abi_x86_32(-)]
		>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
	)
"

DEPEND="games-util/loki_patch"

S=${WORKDIR}

QA_TEXTRELS="
opt/ssamtfe/Bin/libGame.so
opt/ssamtfe/Bin/libEntities.so
opt/ssamtfe/Bin/libamp11lib.so
opt/ssamtfe/Bin/libShaders.so
"

QA_FLAGS_IGNORED="
opt/ssamtfe/Bin/libEntities.so
opt/ssamtfe/Bin/libGame.so
opt/ssamtfe/Bin/libamp11lib.so
opt/ssamtfe/Bin/libShaders.so
opt/ssamtfe/Bin/ssam_lnxded
opt/ssamtfe/Bin/ssam_lnxded.dynamic
opt/ssamtfe/Bin/ssam_lnx.dynamic
opt/ssamtfe/Bin/ssam_lnx
"

pkg_setup() {
	games_pkg_setup

	cdrom_get_cds "Install/1_00c.gro"
}

src_unpack() {
	mkdir Mods Levels
	unpack_makeself ssam-tfe-lnx-beta1a.run

	# Copy files during unpack as the patches below apply to some of them
	einfo "Copying from ${CDROM_ROOT}"
	cp -r "${CDROM_ROOT}/Install"/* . || die "copy from CD failed"

	nonfatal unpack ./SeriousSamPatch105_USA_linux.tar.bz2
	unpack ./setupstuff.tar.gz
	unpack ./bins.tar.bz2

	# We need only runscript from bin/ directory
	mv bin/${MY_PN} .
	rm -r bin
}

src_prepare() {
	# Apply the Icculus patches
	local v
	for v in 1b 2 3 ; do
		echo "Unpacking version ${v}"
		unpack_makeself "${MY_PN}-beta${v}.sh.bin"
		loki_patch patch.dat . || die "loki patch ${v} failed"
		rm patch.dat
	done

	# Remove unneeded files from Loki patches
	rm -r bin

	# Switch to dynamic executable - runs at sane speeds on modern hardware
	sed -i -e 's;exec "./ssam_lnx";exec "./ssam_lnx.dynamic";' ${MY_PN} \
		|| die "dynamic binary update failed"
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${MY_PN}

	# Remove bundled libs
	rm Bin/{libogg,libvorbis,libvorbisfile}.so

	# Remove unneeded files
	rm *.{bin,bz2,cab,exe,ex_,ini,gz,sh}
	rm -r data setup* Players Temp

	# Install icon
	newicon ssam.xpm ${MY_PN}.xpm

	# Install documentation
	dodoc README*

	# Install all other files
	insinto "${dir}"
	doins -r *

	# Install executables and wrapper script
	exeinto "${dir}"
	doexe ${MY_PN}
	exeinto "${dir}"/Bin
	doexe Bin/ssam_lnx*

	games_make_wrapper ${MY_PN} ./${MY_PN} "${dir}" "${dir}"
	make_desktop_entry ${MY_PN} "Serious Sam - First Encounter" ${MY_PN}

	# Ensure that file datestamps from the CD are sane
	find "${D}/${dir}" -exec touch '{}' \;

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "The warning regarding 'XiG-SUNDRY-NONSTANDARD missing' is harmless"
	echo
}
