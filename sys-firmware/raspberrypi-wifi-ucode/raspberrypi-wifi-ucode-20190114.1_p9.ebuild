# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Most up-to-date uCode for the Broadcom wifi chips on Raspberry Pi SBCs"
HOMEPAGE="https://github.com/RPi-Distro/firmware-nonfree
	https://archive.raspberrypi.org/debian/pool/main/f/firmware-nonfree"
MY_PN=firmware-nonfree
SRC_URI="https://archive.raspberrypi.org/debian/pool/main/f/${MY_PN}/${MY_PN}_$(ver_cut 1)-$(ver_cut 2)+rpt$(ver_cut 4).debian.tar.xz"

LICENSE="Broadcom"
SLOT="0"
KEYWORDS="~arm ~arm64"

RDEPEND="!sys-kernel/linux-firmware[-savedconfig]"
DEPEND=""

S="${WORKDIR}"

pkg_setup() {
	local -a BADFILES=()
	local txt file
	# /lib/firmware/brcm/brcmfmac434{30,36,55,56}-sdio.*.txt
	# The above pattern works because the files we want to hit
	# have names of the form:
	# * /lib/firmware/brcm/brcmfmac43430-sdio.AP6212.txt
	# * /lib/firmware/brcm/brcmfmac43430-sdio.Hampoo-D2D3_Vi8A1.txt
	# * /lib/firmware/brcm/brcmfmac43430-sdio.MUR1DX.txt
	# * /lib/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt
	# * /lib/firmware/brcm/brcmfmac43455-sdio.MINIX-NEO Z83-4.txt
	# * /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-a-plus.txt
	# * /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt
	# * /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.txt
	# While the files installed by raspberrypi-wifi-ucode have names
	# of the form:
	# * /lib/firmware/brcm/brcmfmac43430-sdio.txt
	# * /lib/firmware/brcm/brcmfmac43436-sdio.txt
	# * /lib/firmware/brcm/brcmfmac43455-sdio.txt
	# * /lib/firmware/brcm/brcmfmac43456-sdio.txt
	# So no overlap is assured.
	for txt in /lib/firmware/brcm/brcmfmac434{30,36,55,56}-sdio.*.txt; do
		[[ -e "${txt}" ]] && BADFILES+=( "${txt}" )
	done
	if (( "${#BADFILES[@]}" >= 1)); then
		eerror "The following files should be excluded from the savedconfig of"
		eerror "linux-firmware and linux-firmware should be re-emerged. Even"
		eerror "though they do not collide with files from ${PN},"
		eerror "they may be loaded preferentially to the files included in"
		eerror "${PN}, leading to undefined behaviour."
		eerror "List of files:"
		for file in "${BADFILES[@]}"; do
			eerror "${file}"
		done
	fi
}

src_prepare() {
	default
	eapply -p1 debian/patches/sdio-txt-files.patch
}

src_install() {
	insinto /lib/firmware/brcm
	doins brcm/*
	dodoc debian/changelog
}
