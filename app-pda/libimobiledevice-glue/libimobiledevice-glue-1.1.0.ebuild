# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Support library for libimobiledevice projects"
HOMEPAGE="https://github.com/libimobiledevice/libimobiledevice-glue"
SRC_URI="https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0/0.1.0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ppc ~ppc64 ~riscv ~s390 x86"

RDEPEND=">=app-pda/libplist-2.3:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
