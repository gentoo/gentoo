# Copyright 2019 Gentoo Authors
# Copyright 2019 Sartura Ltd.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs git-r3

DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
EGIT_REPO_URI="https://github.com/libbpf/libbpf.git"


LICENSE="LGPL-2.1 BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+static-libs"

COMMON_DEPEND="virtual/libelf
	!<=dev-util/bcc-0.7.0"
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${P}/src"

src_compile() {
	emake \
		BUILD_SHARED=y \
		LIBSUBDIR="$(get_libdir)" \
		$(usex static-libs 'BUILD_STATIC=y' '' '' '') \
		CC="$(tc-getCC)"
}

src_install() {
	emake \
		BUILD_SHARED=y \
		LIBSUBDIR="$(get_libdir)" \
		DESTDIR="${D}" \
		$(usex static-libs 'BUILD_STATIC=y' '' '' '') \
		install install_uapi_headers

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
