# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cdrom eutils versionator unpacker

# MY_PV will be e.g. "beta1"
MY_PN="ssamtse"
MY_PV=$(get_version_component_range 2-2)

DESCRIPTION="Serious Sam: The Second Encounter"
HOMEPAGE="http://www.croteam.com/
	http://www.seriouszone.com/"
SRC_URI="http://icculus.org/betas/ssam/${MY_PN}-${MY_PV}.sh.bin"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist mirror strip"
IUSE="alsa"

DEPEND=">=app-arch/unshield-0.6"
RDEPEND="
	>=media-libs/libogg-1.3.1[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[X,joystick,opengl,video,abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	alsa? (
		>=media-libs/libsdl-1.2.15-r5[alsa,sound,abi_x86_32(-)]
		>=media-libs/libvorbis-1.3.3-r1[abi_x86_32(-)]
	)
"

S=${WORKDIR}

QA_TEXTRELS="
opt/ssamtse/Bin/libEntitiesMP.so
opt/ssamtse/Bin/libGameMP.so
opt/ssamtse/Bin/libamp11lib.so
opt/ssamtse/Bin/libShaders.so
"

QA_FLAGS_IGNORED="
opt/ssamtse/Bin/libEntitiesMP.so
opt/ssamtse/Bin/libGameMP.so
opt/ssamtse/Bin/libamp11lib.so
opt/ssamtse/Bin/libShaders.so
opt/ssamtse/Bin/ssam_lnxded
opt/ssamtse/Bin/ssam_lnxded.dynamic
opt/ssamtse/Bin/ssam_lnx.dynamic
opt/ssamtse/Bin/ssam_lnx
"

pkg_setup() {
	cdrom_get_cds "Install/SE1_00.gro"
}

src_unpack() {
	mkdir Levels Mods

	unpack_makeself "${MY_PN}-${MY_PV}.sh.bin"
	unpack ./setupstuff.tar.gz
	unpack ./bins.tar.bz2
}

src_prepare() {
	# Switch to dynamic executable - runs at sane speeds on modern hardware
	sed -i -e 's;exec "./ssam_lnx";exec "./ssam_lnx.dynamic";' bin/${MY_PN} \
		|| die "dynamic binary update failed"
}

src_install() {
	local dir="/opt/${MY_PN}"

	# Remove bundled libs
	rm -f Bin/{libogg.so,libvorbis.so,libvorbisfile.so} || die "failed to remove bundled libs"

	einfo "Copying from ${CDROM_ROOT}"
	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/Install/*

	# Correct paths of copied resource files
	mv "${D}/${dir}"/Locales/eng/Controls/* "${D}/${dir}"/Controls/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Data/Var/* "${D}/${dir}"/Data/Var/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Demos/* "${D}/${dir}"/Demos/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Help/* "${D}/${dir}"/Help/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Mods/Warped/Scripts/Addons/WarpedTweak.des "${D}/${dir}"/Mods/Warped/Scripts/Addons/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Mods/Warped/Readme.html "${D}/${dir}"/Mods/Warped/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Mods/*.des "${D}/${dir}"/Mods/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Scripts/Addons/* "${D}/${dir}"/Scripts/Addons/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Scripts/CustomOptions/* "${D}/${dir}"/Scripts/CustomOptions/ || die "Failed to move file"
	mv "${D}/${dir}"/Locales/eng/Scripts/NetSettings/* "${D}/${dir}"/Scripts/NetSettings/ || die "Failed to move file"
	rm -rf "${D}/${dir}"/Locales || die "failed to removed Locales dir"

	# The data CABs contain optional multiplayer maps in the "Levels" directory
	einfo "Extracting additional levels"
	unshield x "${D}/${dir}"/data1.cab >/dev/null || die "unshield data1.cab failed"
	rm "${D}/${dir}"/data?.cab || die "Failed to remove cab"

	# Correct paths of extracted levels
	mv Levels/Levels/LevelsMP/* Levels/LevelsMP/ || die "Failed to move file"
	rm -rf Levels/Levels || die "Failed to remove dir"
	mv Levels/LevelsMP/Technology/* Levels/ || die "Failed to move file"
	rmdir Levels/LevelsMP/Technology  || die "Failed to remove dir"
	mv Levels/Mods/Warped/ Mods/ || die "Failed to move file"
	rmdir Levels/Mods/ || die "Failed to remove dir"

	doins -r Bin Data Levels Mods *.txt README*

	# Install bins last to ensure they are marked executable
	exeinto "${dir}"
	doexe bin/${MY_PN}
	exeinto "${dir}"/Bin
	doexe Bin/{ssam_lnx*,*.so}

	# Remove useless Windows files
	rm -rf "${D}/${dir}/Bin"/{*.exe,*.dll,*.DLL,GameSpy} || die "Failed to remove windows cruft"
	rm -f "${D}/${dir}"/{*.exe,*.ex_,*.bmp,*.inx,*.hdr,*.bin} || die "Failed to remove windows cruft"

	dodoc README.linux

	newicon ssam.xpm ${MY_PN}.xpm
	make_wrapper ${MY_PN} ./${MY_PN} "${dir}" "${dir}"
	make_desktop_entry ${MY_PN} "Serious Sam - Second Encounter" ${MY_PN}

	# Ensure that file datestamps from the CD are sane
	find "${D}/${dir}" -exec touch '{}' \; || die "touch failed"
}

pkg_postinst() {
	elog "The warning regarding 'XiG-SUNDRY-NONSTANDARD missing' is harmless."
	elog "Important information about the Linux port is at:"
	elog "   http://files.seriouszone.com/download.php?fileid=616"
	echo
}
