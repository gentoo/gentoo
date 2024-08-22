# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit udev

DESCRIPTION="Udev rules to allow easier customization of kernel I/O schedulers"
HOMEPAGE="https://gitlab.com/pachoramos/io-scheduler-udev-rules"
SRC_URI="https://gitlab.com/pachoramos/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="virtual/udev"

src_install() {
	insinto /etc/default
	doins etc/default/io-scheduler
	udev_dorules udev/rules.d/60-io-scheduler.rules
	einstalldocs
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
