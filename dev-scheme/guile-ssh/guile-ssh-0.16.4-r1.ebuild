# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library providing access to the SSH protocol for GNU Guile"
HOMEPAGE="https://memory-heap.org/~avp/projects/guile-ssh/
	https://github.com/artyom-poptsov/guile-ssh/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/artyom-poptsov/${PN}.git"
else
	SRC_URI="https://github.com/artyom-poptsov/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	net-libs/libssh:0=[server,sftp]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )
PATCHES=(
	"${FILESDIR}/${PN}-0.16.2-tests.patch"
)

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

src_prepare() {
	default
	eautoreconf

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die

	# Workaround llvm-strip problem of mangling guile ELF debug
	# sections: https://bugs.gentoo.org/905898
	dostrip -x "/usr/$(get_libdir)/guile"
}
