# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multiprocessing toolchain-funcs

MY_PV="VERSION_${PV//./_}"
DESCRIPTION="Markdown translator producing HTML5, roff documents in the ms and man formats"
HOMEPAGE="https://kristaps.bsd.lv/lowdown/"
SRC_URI="https://github.com/kristapsdz/lowdown/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="ISC"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~sparc x86"

DEPEND="
	virtual/libcrypt:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-build/bmake
"

# configure tests for a bunch of BSD functions on Linux
QA_CONFIG_IMPL_DECL_SKIP=(
	crypt_newhash
	crypt_checkpass
	warnc
	errc
	getexecname
	getprogname
	memset_s
	pledge
	recallocarray
	strlcat
	strlcpy
	strtonum
	TAILQ_FOREACH_SAFE
	unveil
	arc4random
	b64_ntop
	timingsafe_bcmp
	timingsafe_memcmp
)

PATCHES=(
	"${FILESDIR}/lowdown-0.10.0-pkgconfig-libmd.patch"
)

src_configure() {
	append-flags -fPIC
	tc-export CC AR

	local jobs="$(makeopts_jobs)"
	unset MAKEOPTS
	unset MAKEFLAGS

	export MAKEOPTS="-j${jobs}"
	export MAKEFLAGS= #966238
	export MAKE=bmake

	./configure \
		PREFIX="${EPREFIX}/usr" \
		MANDIR="${EPREFIX}/usr/share/man" \
		LDFLAGS="${LDFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		|| die "./configure failed"
}

src_compile() {
	emake $(usex elibc_musl UTF8_LOCALE=C.UTF-8 '')
}

src_test() {
	LD_LIBRARY_PATH="${S}" emake regress
}
