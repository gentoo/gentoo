# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a flag-o-matic toolchain-funcs

DESCRIPTION="Stand-alone build of libbpf from the Linux kernel"
HOMEPAGE="https://github.com/libbpf/libbpf"

if [[ ${PV} =~ [9]{4,} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libbpf/libbpf.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2 LGPL-2.1 BSD-2"
SLOT="0/$(ver_cut 1-2)"
IUSE="static-libs"

# libbpf headers referenece linux-headers, so we keep it in RDEPEND
DEPEND="
	sys-kernel/linux-headers
	>=virtual/libelf-3:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=(
	../{README,SYNC}.md
)

src_configure() {
	append-cflags -fPIC
	tc-export CC AR PKG_CONFIG
	use static-libs && lto-guarantee-fat
	export PREFIX="${EPREFIX}/usr"
	export LIBDIR="\$(PREFIX)/$(get_libdir)"
	export V=1
}

src_install() {
	emake DESTDIR="${D}" install

	if ! use static-libs; then
		find "${ED}" -name '*.a' -delete || die
	fi

	strip-lto-bytecode

	dodoc "${DOCS[@]}"

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
}
