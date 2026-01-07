# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit edo toolchain-funcs flag-o-matic unpacker verify-sig

DESCRIPTION="Copy data from one file or block device to another with read-error recovery"
HOMEPAGE="https://www.gnu.org/software/ddrescue/ddrescue.html"
SRC_URI="
	mirror://gnu/${PN}/${P}.tar.lz
	verify-sig? ( mirror://gnu/${PN}/${P}.tar.lz.sig )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="static"

BDEPEND="
	$(unpacker_src_uri_depends)
	verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )
"

src_unpack() {
	use verify-sig && verify-sig_src_unpack
	unpacker ${P}.tar.lz
}

src_configure() {
	use static && append-ldflags -static

	# not a normal configure script
	edo ./configure \
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
