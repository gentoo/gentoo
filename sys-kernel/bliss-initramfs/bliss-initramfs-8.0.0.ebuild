# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
inherit python-single-r1

DESCRIPTION="Boot your system's rootfs from OpenZFS/LUKS"
HOMEPAGE="https://github.com/fearedbliss/bliss-initramfs"
SRC_URI="https://github.com/fearedbliss/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/cpio
	virtual/udev"

S="${WORKDIR}/${PN}-${PV}"

src_install() {
	# Copy the main executable
	local executable="mkinitrd.py"
	exeinto "/opt/${PN}"
	doexe "${executable}"

	# Copy the libraries required by this executable
	cp -r "${S}/files" "${D}/opt/${PN}" || die
	cp -r "${S}/pkg" "${D}/opt/${PN}" || die

	# Copy documentation files
	dodoc README.md README-MORE USAGE

	# Make a relative symbolic link: /sbin/bliss-initramfs
	dosym "../opt/${PN}/${executable}" "/sbin/${PN}"
}
