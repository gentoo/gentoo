# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

MY_PV="VERSION_${PV//./_}"
DESCRIPTION="Markdown translator producing HTML5, roff documents in the ms and man formats"
HOMEPAGE="https://kristaps.bsd.lv/lowdown/"
SRC_URI="https://github.com/kristapsdz/lowdown/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	virtual/libcrypt:=
"
RDEPEND="
	${DEPEND}
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
)

PATCHES=(
	"${FILESDIR}/lowdown-0.10.0-pkgconfig-libmd.patch"
	"${FILESDIR}/lowdown-1.1.0-shared-linking.patch"
)

src_configure() {
	append-flags -fPIC
	tc-export CC AR

	./configure \
		PREFIX="/usr" \
		MANDIR="/usr/share/man" \
		LDFLAGS="${LDFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LIBDIR="/usr/$(get_libdir)" \
		|| die "./configure failed"
}

src_compile() {
	emake $(usex elibc_musl UTF8_LOCALE=C.UTF-8 '')
}

src_test() {
	LD_LIBRARY_PATH="${S}" emake regress
}
