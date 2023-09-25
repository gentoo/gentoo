# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Guile modules for generating parsers and lexical analyzers"
HOMEPAGE="http://www.nongnu.org/nyacc/"
SRC_URI="mirror://nongnu/nyacc/nyacc-${PV}.tar.gz"
S="${WORKDIR}/nyacc-${PV}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-scheme/guile-2.0.0:=
	dev-scheme/bytestructures
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

src_install() {
	default

	# Fix docs location
	mv "${D}"/usr/share/doc/nyacc "${D}"/usr/share/doc/${PF}

	# Workaround llvm-strip problem of mangling guile ELF debug
	# sections: https://bugs.gentoo.org/905898
	dostrip -x "/usr/$(get_libdir)/guile"
}
