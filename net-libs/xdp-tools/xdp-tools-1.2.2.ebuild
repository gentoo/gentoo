# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The libxdp library and various tools for use with XDP"
HOMEPAGE="https://github.com/xdp-project/xdp-tools"
SRC_URI="https://github.com/xdp-project/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

IUSE="+tools"

DEPEND="dev-libs/libbpf:=
	sys-libs/zlib
	net-libs/libpcap
	virtual/libelf"
RDEPEND="${DEPEND}"
BDEPEND=">=sys-devel/clang-10.0.0"

# Not prebuilt -- we build them -- but they're not ordinary ELF objects either.
QA_PREBUILT="usr/lib/bpf/*.o"

MAKEOPTS+=" V=1"

src_configure() {
	export PRODUCTION=1
	export DYNAMIC_LIBXDP=1
	export FORCE_SYSTEM_LIBBPF=1
	default
}

src_install() {
	export PREFIX="${EPREFIX}/usr"
	export LIBDIR="${PREFIX}/$(get_libdir)"
	export BPF_OBJECT_DIR="${PREFIX}/lib/bpf"
	default

	# To remove the scripts/testing files that are installed.
	rm -r "${ED}/usr/share/xdp-tools" || die
	# We can't control static archive generation yet.
	rm "${ED}/usr/$(get_libdir)/libxdp.a" || die

	use tools || { rm "${ED}/usr/sbin"/* || die; }

	# These are ELF objects but BPF ones.
	dostrip -x /usr/lib/bpf
}
