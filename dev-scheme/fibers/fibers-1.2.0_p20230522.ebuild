# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20230522 ]] && COMMIT=83712f630a976e3084329c9917c40bde19fcc7e5

inherit autotools

DESCRIPTION="Lightweight concurrency facility for Guile Scheme"
HOMEPAGE="https://github.com/wingo/fibers/
	https://github.com/wingo/fibers/wiki/Manual/"
SRC_URI="https://github.com/wingo/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-scheme/guile-2.1.7:="
DEPEND="${RDEPEND}"

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die

	eautoreconf
}

src_configure() {
	econf --disable-Werror
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die

	# Workaround llvm-strip problem of mangling guile ELF debug
	# sections: https://bugs.gentoo.org/905898
	dostrip -x "/usr/$(get_libdir)/guile"
}
