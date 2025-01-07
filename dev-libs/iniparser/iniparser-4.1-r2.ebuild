# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Free stand-alone ini file parsing library"
HOMEPAGE="https://github.com/ndevilla/iniparser/"
SRC_URI="
	https://github.com/ndevilla/iniparser/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc examples"

BDEPEND="doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-CVE-null-getstring.patch
)

src_prepare() {
	default

	rm -r html || die
}

src_compile() {
	append-lfs-flags
	tc-export AR CC

	emake V=1 ADDITIONAL_CFLAGS=
	use doc && emake -C doc
}

src_test() {
	emake V=1 -C test
}

src_install() {
	dolib.so lib${PN}.so.1
	dosym -r /usr/$(get_libdir)/lib${PN}.so{.1,}

	doheader src/*.h

	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	use doc && local HTML_DOCS=( html/. )
	einstalldocs
}
