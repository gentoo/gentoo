# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cdrom unpacker

# Game name
GN="serioussamse"
PATCH_PREFIX="${GN}-patch_1.07_SE"

DESCRIPTION="Croteam's Serious Sam Classic The Second Encounter ... the data files"
HOMEPAGE="https://www.croteam.com/
	https://store.steampowered.com/app/41060/Serious_Sam_Classic_The_Second_Encounter/"
SRC_URI="https://github.com/tx00100xt/serioussam-mods/raw/main/Patches/${PATCH_PREFIX}.tar.xz"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist"

pkg_setup() {
	cdrom_get_cds "Install/SE1_00_Levels.gro"
}

src_unpack() {
	mkdir Levels Mods || die "failed create dirs"
	cat "${DISTDIR}/${PATCH_PREFIX}.tar.xz" > "${PATCH_PREFIX}.tar.xz" \
		|| die "failed to copy patch 1.07"
	unpack "${WORKDIR}/${PATCH_PREFIX}.tar.xz"
}

src_install() {
	local dir="/usr/share/${GN}"

	einfo "Copying from ${CDROM_ROOT}"
	insinto "${dir}"
	doins -r "${CDROM_ROOT}"/Install/*

	mv "${WORKDIR}"/*.gro "${ED}${dir}" || die "failed to moved patch 1.07"
	mv "${ED}${dir}"/Scripts/PersistentSymbols.ini "${WORKDIR}" \
		|| die "failed to moved PersistentSymbols.ini"

	rm -rf \
		"${ED}${dir}"/{Bin,Controls,Data,Demos,Mods,Players,Scripts,Locales} \
		|| die "failed to remove directories"
	rm -rf \
		"${ED}${dir}"/{VirtualTrees,ModEXT.txt,Help/ShellSymbols.txt} \
		|| die "failed to remove directories"
	mkdir "${ED}${dir}/Scripts" || die "failed create Scripts dir"
	mv "${WORKDIR}"/PersistentSymbols.ini "${ED}${dir}/Scripts" \
		|| die "failed to moved PersistentSymbols.ini"

	# Remove useless Windows files
	rm -f "${ED}${dir}"/{*.exe,*.ex_,*.bmp,*.inx,*.hdr,*.bin,*.cab,*.ini,*.log} \
		|| die "Failed to remove windows cruft"

	# Ensure that file datestamps from the CD are sane
	find "${ED}${dir}"/Levels -exec touch -d '09 May 2020 14:00' '{}' \; \
		|| die "touch failed"
}

pkg_postinst() {
	elog "Important information about the Linux port is at:"
	elog "  https://github.com/tx00100xt/SeriousSamClassic-VK"
	elog "    look at:"
	elog "  https://github.com/tx00100xt/SeriousSamClassic-VK/wiki"
	elog "   For information about of the game"
}
