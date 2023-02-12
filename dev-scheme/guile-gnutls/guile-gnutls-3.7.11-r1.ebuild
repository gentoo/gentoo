# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Guile-GnuTLS provides Guile bindings for the GnuTLS library"
HOMEPAGE="https://gnutls.gitlab.io/guile/manual/
	https://gitlab.com/gnutls/guile/"
SRC_URI="https://gitlab.com/gnutls/guile/uploads/56e18069ab63ca67d61aecb6b2697ec1/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	net-libs/gnutls:=[-guile(-)]
"
DEPEND="${RDEPEND}"

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_configure() {
	econf --disable-srp-authentication  # bug #894050
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
