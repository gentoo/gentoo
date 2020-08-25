# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info meson systemd

DESCRIPTION="Userspace system daemon to enable security levels for Thunderbolt 3"
HOMEPAGE="https://gitlab.freedesktop.org/bolt/bolt"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc systemd"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	dev-util/glib-utils
	virtual/libudev
	virtual/udev
	dev-util/umockdev
	sys-auth/polkit[introspection]
	systemd? ( sys-apps/systemd )
	doc? ( app-text/asciidoc )"
RDEPEND="${DEPEND}"

pkg_pretend() {
	CONFIG_CHECK="~THUNDERBOLT"
	ERROR_THUNDERBOLT="This package requires the thunderbolt kernel driver."
	check_extra_config

	CONFIG_CHECK="~HOTPLUG_PCI"
	ERROR_HOTPLUG_PCI="Thunderbolt requires PCI hotplug support."
	check_extra_config
}

src_configure() {
	local emesonargs=(
		-Dman=$(usex doc true false)
		--sysconfdir=/etc
		--localstatedir=/var
		--sharedstatedir=/var/lib
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newinitd "${FILESDIR}"/${PN}.openrc boltd
	keepdir /var/lib/boltd
}
