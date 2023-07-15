# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="System settings D-Bus service for OpenRC"
HOMEPAGE="https://gitlab.com/postmarketOS/openrc-settingsd/"
SRC_URI="https://gitlab.com/postmarketOS/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="systemd"

DEPEND="
	>=dev-libs/glib-2.30:2
	sys-apps/dbus
	sys-auth/polkit
	dev-libs/libdaemon:0=
	sys-apps/openrc
"
RDEPEND="
	${DEPEND}
	systemd? ( >=sys-apps/systemd-197 )
	!systemd? ( sys-auth/nss-myhostname !sys-apps/systemd )
"
BDEPEND="
	dev-util/gdbus-codegen
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	local emesonargs=(
		-Dopenrc=enabled
		-Denv-update=/usr/bin/env-update
		-Dhostname-style=gentoo
		-Dlocale-style=gentoo
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use systemd; then
		# Avoid file collision with systemd
		rm -vr "${ED}"/usr/share/{dbus-1,polkit-1} "${ED}"/etc/dbus-1 || die "rm failed"
	fi
}

pkg_postinst() {
	if use systemd; then
		elog "You installed ${PN} with USE=systemd. In this mode,"
		elog "${PN} will not start via simple dbus activation, so you"
		elog "will have to manually enable it as an rc service:"
		elog " # /etc/init.d/openrc-settingsd start"
		elog " # rc-update add openrc-settingsd default"
	fi
}
