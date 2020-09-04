# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libbpf/libbpf.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi
S="${WORKDIR}/${P}/src"

HOMEPAGE="https://github.com/libbpf/libbpf"
DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0/${PV}"

COMMON_DEPEND="virtual/libelf
	!<=dev-util/bcc-0.7.0"
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers"
RDEPEND="${COMMON_DEPEND}"

src_configure() {
	append-cflags -fPIC
	tc-export CC
	export PREFIX="${EPREFIX}/usr"
	export LIBSUBDIR="$(get_libdir)"
}
