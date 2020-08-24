# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

HOMEPAGE="https://github.com/libbpf/libbpf"
DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"

COMMON_DEPEND="virtual/libelf
	!<=dev-util/bcc-0.7.0"
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${P}/src"

src_configure() {
	tc-export CC
	export PREFIX="${EPREFIX}/usr"
	export LIBSUBDIR="$(get_libdir)"
}
