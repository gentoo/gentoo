# Copyright 2019 Sony Interactive Entertainment Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

EGIT_COMMIT="cb658e9724e3c34973eee913b1ff0cb9c50b8e53"

HOMEPAGE="https://github.com/libbpf/libbpf"
DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
SRC_URI="https://github.com/${PN}/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

COMMON_DEPEND="virtual/libelf
	!<=dev-util/bcc-0.7.0"
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}/src"

PATCHES=(
	"${FILESDIR}/libbpf-makefile.patch"
)

src_prepare() {
	# upstream doesn't provide a pkgconfig file, so
	# let's make one
	printf 'prefix=/usr\nexec_prefix=${prefix}\nlibdir=%s\n' \
			"/usr/$(get_libdir)" \
		> ${PN}.pc
	printf 'includedir=${prefix}/include\n\n' \
		>> ${PN}.pc

	printf 'Name: %s\nDescription: %s\nVersion: %s\nLibs: -lbpf %s\n' \
			"${PN}" \
			"${DESCRIPTION}" \
			"${PV}" \
			"$($(tc-getPKG_CONFIG) --libs libelf)" \
		>> ${PN}.pc

	default
}

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
		install

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
