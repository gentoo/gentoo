# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson udev

DESCRIPTION="Userspace system daemon to enable security levels for Thunderbolt 3"
HOMEPAGE="https://gitlab.freedesktop.org/bolt/bolt"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	virtual/libudev:=
	virtual/udev
	sys-auth/polkit[introspection]
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/umockdev )
"
BDEPEND="
	app-text/asciidoc
	dev-util/glib-utils
	virtual/pkgconfig
"

pkg_setup() {
	if use kernel_linux && kernel_is lt 5 6; then
		CONFIG_CHECK="~THUNDERBOLT"
		ERROR_THUNDERBOLT="This package requires the thunderbolt kernel driver."
	else
		CONFIG_CHECK="~USB4"
		ERROR_USB4="This package requires the USB4 kernel driver for Thunderbolt support."
	fi
	CONFIG_CHECK+=" ~HOTPLUG_PCI"
	ERROR_HOTPLUG_PCI="Thunderbolt requires PCI hotplug support."

	linux-info_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dman=true
		--sysconfdir="${EPREFIX}"/etc
		--localstatedir="${EPREFIX}"/var
		--sharedstatedir="${EPREFIX}"/var/lib
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newinitd "${FILESDIR}"/${PN}.openrc-r1 boltd
	keepdir /var/lib/boltd
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
