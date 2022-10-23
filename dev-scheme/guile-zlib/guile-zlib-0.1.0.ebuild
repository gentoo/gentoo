# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GNU Guile library providing bindings to zlib"
HOMEPAGE="https://notabug.org/guile-zlib/guile-zlib/"
SRC_URI="https://notabug.org/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog HACKING NEWS README.org )
PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

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
	# Gentoo installs zlib to /${libdir} and to /usr/${libdir}.
	# We need /${libdir} with shared library here.
	econf LIBZ_LIBDIR="${EPREFIX}/$(get_libdir)"
}
