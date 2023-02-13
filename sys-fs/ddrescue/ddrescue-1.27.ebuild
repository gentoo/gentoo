# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic unpacker

DESCRIPTION="Copy data from one file or block device to another with read-error recovery"
HOMEPAGE="https://www.gnu.org/software/ddrescue/ddrescue.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.lz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
IUSE="static"

BDEPEND="$(unpacker_src_uri_depends)"

src_configure() {
	use static && append-ldflags -static

	# not a normal configure script
	econf \
		--prefix="${EPREFIX}"/usr \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_test() {
	./testsuite/check.sh "${S}"/testsuite || die
}

src_install() {
	emake DESTDIR="${D}" install install-man
	einstalldocs
}
