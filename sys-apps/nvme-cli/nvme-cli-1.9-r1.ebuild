# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs udev

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="+uuid"

RDEPEND="uuid? ( sys-apps/util-linux:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e 's|^LIBUUID =|LIBUUID ?=|' \
		-e 's|^install-hostparams:$|\0 install-etc|' \
		-i Makefile || die
}

src_configure() {
	tc-export CC
	export PREFIX="${EPREFIX}/usr"
	export SYSTEMDDIR="$(systemd_get_systemunitdir)"
	export UDEVDIR="${EPREFIX}$(get_udevdir)"
	MAKEOPTS+=" LIBUUID=$(usex uuid 0 1)"
}
