# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson systemd udev

DESCRIPTION="A simple jobserver for Gentoo"
HOMEPAGE="https://gitweb.gentoo.org/proj/steve.git/"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug"

DEPEND="
	dev-libs/libevent:=
	sys-fs/fuse:3=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

pkg_pretend() {
	local CONFIG_CHECK="~CUSE"
	check_extra_config
}

src_configure() {
	local emesonargs=(
		$(meson_use !debug b_ndebug)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# TODO: move these to meson
	systemd_dounit data/steve.service
	newconfd data/steve.confd steve
	newinitd data/steve.initd steve
	insinto /etc/sandbox.d
	newins data/sandbox.conf 90steve
	udev_newrules data/steve.udev 90-steve.rules
}

pkg_postinst() {
	udev_reload

	if ! grep -q -s -R -- '--jobserver-auth=fifo:/dev/steve' "${EROOT}"/etc/portage/make.conf
	then
		elog "In order to use the system-wide steve instance, enable the service:"
		elog
		elog "  systemctl enable --now steve"
		elog
		elog "Then add to your make.conf:"
		elog
		elog '  MAKEFLAGS="--jobserver-auth=fifo:/dev/steve"'
		elog '  NINJAOPTS=""'
		elog
		elog "You can use -l in NINJAOPTS but *do not* use -j, as it disables"
		elog "jobserver support."
	fi
}

pkg_postrm() {
	udev_reload
}
