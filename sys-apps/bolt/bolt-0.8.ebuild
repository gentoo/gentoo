# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson systemd

DESCRIPTION="Userspace system daemon to enable security levels for Thunderbolt 3."
HOMEPAGE="https://gitlab.freedesktop.org/bolt/bolt"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc systemd"

DEPEND="
	>=dev-libs/glib-2.50.0:2
	dev-util/glib-utils
	virtual/libudev
	virtual/udev
	dev-util/umockdev
	sys-auth/polkit[introspection]
	systemd? ( sys-apps/systemd )
	doc? ( app-text/asciidoc )"
RDEPEND="${DEPEND}"

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
	keepdir /var/lib/boltd
}
