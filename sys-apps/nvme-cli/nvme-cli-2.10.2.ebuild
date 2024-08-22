# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd udev

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
SRC_URI="https://github.com/linux-nvme/nvme-cli/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="+json pdc"

RDEPEND="
	>=sys-libs/libnvme-1.10:=[json?]
	json? ( dev-libs/json-c:= )
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dversion-tag="${PV}"
		-Ddocs=all
		-Dhtmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		-Dsystemddir="$(systemd_get_systemunitdir)"
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
		$(meson_feature json json-c)
		$(meson_use pdc pdc-enabled)
	)
	meson_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
