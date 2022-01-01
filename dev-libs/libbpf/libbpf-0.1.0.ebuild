# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

HOMEPAGE="https://github.com/libbpf/libbpf"
DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+static-libs"

COMMON_DEPEND="virtual/libelf
	!<=dev-util/bcc-0.7.0"
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/libbpf-0.0.7-paths.patch"
)

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
