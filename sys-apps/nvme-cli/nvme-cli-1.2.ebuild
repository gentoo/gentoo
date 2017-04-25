# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
SRC_URI="https://github.com/linux-nvme/nvme-cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="udev"

RDEPEND="sys-libs/libcap:=
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CC
	export PREFIX="${EPREFIX}/usr"
	MAKEOPTS+=" LIBUDEV=$(usex udev 0 1)"
}
