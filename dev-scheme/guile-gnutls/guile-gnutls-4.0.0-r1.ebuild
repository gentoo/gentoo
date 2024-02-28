# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Guile-GnuTLS provides Guile bindings for the GnuTLS library"
HOMEPAGE="https://gnutls.gitlab.io/guile/manual/
	https://gitlab.com/gnutls/guile/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.com/gnutls/guile.git"
else
	SRC_URI="https://gitlab.com/gnutls/guile/-/archive/v${PV}/guile-v${PV}.tar.bz2
		-> ${P}.tar.bz2"
	S="${WORKDIR}/guile-v${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	net-libs/gnutls:=[-guile(-)]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

src_prepare() {
	default
	eautoreconf

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_configure() {
	econf --disable-srp-authentication  # bug #894050
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die

	# Workaround llvm-strip problem of mangling guile ELF debug
	# sections: https://bugs.gentoo.org/905898
	dostrip -x "/usr/$(get_libdir)/guile"
}
