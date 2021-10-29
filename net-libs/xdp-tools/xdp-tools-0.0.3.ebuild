# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The libxdp library and various tools for use with XDP"
HOMEPAGE="https://github.com/xdp-project/xdp-tools"
SRC_URI="https://github.com/xdp-project/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+doc +tools static-libs"

DEPEND="dev-libs/libbpf
	sys-libs/zlib
	net-libs/libpcap
	virtual/libelf"
RDEPEND="${DEPEND}"
BDEPEND=">=sys-devel/clang-10.0.0
	doc? ( app-editors/emacs )"

# Not prebuilt -- we build them -- but they're not ordinary ELF objects either.
QA_PREBUILT="usr/lib/bpf/*.o"

MAKEOPTS+=" V=1"

src_prepare() {
	# A form of this kludge is upstream but hasn't yet been released:
	sed -i 's/install -m 0755 \$(SHARED_LIBS)/cp -fpR \$(SHARED_LIBS)/' lib/libxdp/Makefile || die
	default
}

src_configure() {
	export PRODUCTION=1
	export DYNAMIC_LIBXDP=1
	export FORCE_EMACS=$(usex doc 1 0)
	default
	{
		echo "PREFIX := ${EPREFIX}/usr"
		echo "LIBDIR := \$(PREFIX)/$(get_libdir)"
		echo "BPF_OBJECT_DIR := \$(PREFIX)/lib/bpf"
	} >> config.mk
}

src_install() {
	default
	use static-libs || rm -f "${D}/${EPREFIX}/usr/$(get_libdir)/libxdp.a"
	use tools || rm -f "${D}/${EPREFIX}/usr/"{sbin,bin}/*
	dostrip -x /usr/lib/bpf
}
