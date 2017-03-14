# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GITHUB_USER="fearedbliss"
GITHUB_REPO="bliss-initramfs"
GITHUB_TAG="${PV}"

DESCRIPTION="Boot your system's rootfs from ZFS, LVM, RAID, or a variety of other configs."
HOMEPAGE="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="strip"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	>=dev-lang/python-3.3
	app-arch/cpio
	virtual/udev"

S="${WORKDIR}/${GITHUB_REPO}-${GITHUB_TAG}"

src_install() {
	# Copy the main executable
	local executable="mkinitrd.py"
	exeinto "/opt/${PN}"
	doexe "${executable}"

	# Copy the libraries required by this executable
	cp -r "${S}/files" "${D}/opt/${PN}" || die
	cp -r "${S}/pkg" "${D}/opt/${PN}" || die

	# Copy documentation files
	dodoc README USAGE

	# Make a symbolic link: /sbin/bliss-initramfs
	dosym "/opt/${PN}/${executable}" "/sbin/${PN}"
}
