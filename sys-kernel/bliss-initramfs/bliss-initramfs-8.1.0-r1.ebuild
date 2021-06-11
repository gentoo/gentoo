# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit python-single-r1

DESCRIPTION="Boot your system's rootfs from OpenZFS/LUKS"
HOMEPAGE="https://github.com/fearedbliss/bliss-initramfs"
SRC_URI="https://github.com/fearedbliss/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="strip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/cpio
	virtual/udev"

DOCS=( README.md README-MORE.md USAGE.md )

CONFIG_FILE="/etc/bliss-initramfs/settings.json"

src_install() {
	# Copy the main executable
	local executable="mkinitrd.py"
	exeinto "/opt/${PN}"
	doexe "${executable}"

	# Copy the libraries required by this executable
	cp -r "${S}/files" "${D}/opt/${PN}" || die
	cp -r "${S}/pkg" "${D}/opt/${PN}" || die

	# Copy the configuration file for the user
	dodir "/etc/${PN}"
	cp "${S}/files/default-settings.json" "${D}${CONFIG_FILE}"

	python_fix_shebang "${D}/opt/${PN}/${executable}"

	# Make a relative symbolic link: /sbin/bliss-initramfs
	dosym "../opt/${PN}/${executable}" "/sbin/${PN}"
}

pkg_postinst() {
	elog "As of version 8.1.0, ${PN} has a new centralized configuration architecture."
	elog "Any customizations you want to provide to ${PN} should be done by modifying"
	elog "${CONFIG_FILE}. You can use the \"-c/--config\" option to provide"
	elog "an alternate configuration path.\n"
	elog "For a full list of changes, please read the release info located here:"
	elog "https://github.com/fearedbliss/bliss-initramfs/releases/tag/8.1.0"
	elog ""
	elog "Also, 8.1.0 is the last version to include support for LUKS! Starting with"
	elog "version 9.0.0, bliss-initramfs only contains support for ZFS' Native Encryption."
	elog "If you are a LUKS/OpenZFS user, please stay on 8.1.0 until you migrate over to"
	elog "the native encryption."
}
