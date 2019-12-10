# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="Traces TeX fonts to PFA or PFB fonts (formerly pktrace)"
HOMEPAGE="http://lilypond.org/mftrace/"
SRC_URI="http://lilypond.org/downloads/sources/mftrace/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
# SLOT 1 was used in pktrace ebuild
SLOT="1"
IUSE="test truetype"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=app-text/t1utils-1.25
	media-gfx/potrace
	truetype? ( media-gfx/fontforge )
	virtual/latex-base
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	test? ( media-gfx/fontforge )"

src_configure() {
	tc-export CC
	econf \
		--datadir="$(python_get_sitedir)"
}

src_compile() {
	emake CFLAGS="-Wall ${CFLAGS}"
}

src_install () {
	default
	python_optimize
}
