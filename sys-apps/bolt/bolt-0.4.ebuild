# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson systemd

DESCRIPTION="Userspace system daemon to enable security levels for Thunderbolt 3."
HOMEPAGE="https://gitlab.freedesktop.org/bolt/bolt"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
	>=dev-libs/glib-2.50.0:2
	virtual/libudev
	virtual/udev
	sys-apps/systemd:0=
	sys-auth/polkit[introspection]
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
