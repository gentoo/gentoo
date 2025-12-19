# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
HOMEPAGE="https://vergenet.net/~conrad/software/xsel"
SRC_URI="https://github.com/kfish/xsel/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
