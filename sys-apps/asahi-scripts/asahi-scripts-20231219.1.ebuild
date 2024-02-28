# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Apple Silicon support scripts"
HOMEPAGE="https://asahilinux.org/"
SRC_URI="https://github.com/AsahiLinux/${PN}/archive/refs/tags/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

PATCHES=(
	"${FILESDIR}/makefile.patch"
	"${FILESDIR}/update-m1n1-dtbs.patch"
)

src_install() {
	default
	emake DESTDIR="${D}" SYS_PREFIX="" install-dracut
}

pkg_postinst() {
	if [[ ! -e ${ROOT}/usr/lib/asahi-boot ]]; then
		ewarn "These scripts are intended for use on Apple Silicon"
		ewarn "machines with the Asahi tooling installed! Please"
		ewarn "install sys-boot/m1n1, sys-boot/u-boot and"
		ewarn "sys-firmware/asahi-firmware!"
	fi

	if [[ -e ${ROOT}/bin/update-m1n1 ]]; then
		ewarn "You need to remove /bin/update-m1n1."
	fi

	if [[ -e ${ROOT}/usr/local/share/asahi-scripts/functions.sh ]]; then
		ewarn "You have upgraded to a new version of ${PN}. Please"
		ewarn "remove /usr/local/share/asahi-scripts/,"
		ewarn " /usr/local/bin/update-m1n1, and"
		ewarn "/usr/local/bin/update-vendor-firmware."
	fi

	if [[ -e ${ROOT}/etc/dracut.conf.d/10-apple.conf ]]; then
		ewarn "Please remove /etc/dracut.conf.d/10-apple.conf"
	fi
}
