# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GNU Guile library providing bindings to zlib"
HOMEPAGE="https://notabug.org/guile-zlib/guile-zlib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://notabug.org/${PN}/${PN}.git"
else
	SRC_URI="https://notabug.org/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	>=sys-libs/zlib-1.3-r4
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README.org )
PATCHES=( "${FILESDIR}/${PN}-0.1.0-gentoo.patch" )

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die

	eautoreconf
}

src_install() {
	default

	# Workaround llvm-strip problem of mangling guile ELF debug
	# sections: https://bugs.gentoo.org/905898
	dostrip -x "/usr/$(get_libdir)/guile"
}
