# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C Library for NVM Express on Linux"
HOMEPAGE="https://github.com/linux-nvme/libnvme"
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+json ssl +uuid"

SRC_URI="https://github.com/linux-nvme/libnvme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
DEPEND="
	json? ( dev-libs/json-c:= )
	ssl? ( >=dev-libs/openssl-1.1:= )
	uuid? ( sys-apps/util-linux:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Dpython=false
	)
	meson_src_configure
}
