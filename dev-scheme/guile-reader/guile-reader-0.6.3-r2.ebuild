# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple framework for building readers for GNU Guile"
HOMEPAGE="https://www.nongnu.org/guile-reader/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

RDEPEND=">=dev-scheme/guile-2.0.0:="
DEPEND="${RDEPEND}"
BDEPEND="dev-util/gperf"

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

	find "${ED}" -type f -name '*.la' -delete || die
}
