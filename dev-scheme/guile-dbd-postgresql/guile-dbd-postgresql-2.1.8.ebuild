# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Guile DBI driver for PostgreSQL"
HOMEPAGE="https://github.com/opencog/guile-dbi/"
SRC_URI="https://github.com/opencog/guile-dbi/archive/guile-dbi-${PV}.tar.gz"
S="${WORKDIR}"/guile-dbi-guile-dbi-${PV}/${PN}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	dev-db/postgresql:*
	>=dev-scheme/guile-2.0.0:=
	dev-scheme/guile-dbi
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-configure.patch )

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

	find "${ED}" -type f -name "*.la" -delete || die
}
