# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
SRC_URI="https://github.com/linux-nvme/nvme-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="+uuid"

RDEPEND="uuid? ( sys-apps/util-linux:= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i 's:^LIBUUID =:LIBUUID ?=:' -i Makefile || die
}

src_configure() {
	tc-export CC
	export PREFIX="${EPREFIX}/usr"
	MAKEOPTS+=" LIBUUID=$(usex uuid 0 1)"
}
