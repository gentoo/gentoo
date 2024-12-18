# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Apple Silicon support scripts"
HOMEPAGE="https://asahilinux.org/"
SRC_URI="https://github.com/AsahiLinux/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="
	virtual/udev
"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" SYS_PREFIX="" install-dracut
	emake DESTDIR="${D}" PREFIX="/usr" install-macsmc-battery

	newinitd "${FILESDIR}/${PN}-macsmc-battery.openrc" "macsmc-battery"

	# install gentoo sys config
	insinto /etc/default
	newins "${FILESDIR}"/update-m1n1.gentoo.conf update-m1n1
	exeinto /usr/lib/kernel/install.d/
	doexe "${FILESDIR}/99-update-m1n1.install"
}

pkg_postinst() {
	if [[ ! -e ${ROOT}/usr/lib/asahi-boot ]]; then
		ewarn "These scripts are intended for use on Apple Silicon"
		ewarn "machines with the Asahi tooling installed! Please"
		ewarn "install sys-boot/m1n1, sys-boot/u-boot and"
		ewarn "sys-firmware/asahi-firmware!"
	fi

	elog "Asahi scripts have been installed to /usr/. For more"
	elog "information on how to use them, please visit the Wiki."
}
