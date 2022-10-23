# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools python-single-r1

DESCRIPTION="A text-based calendar and scheduling application"
HOMEPAGE="https://calcurse.org/"
SRC_URI="https://calcurse.org/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/httplib2[${PYTHON_USEDEP}]')
	sys-libs/ncurses:0="

DEPEND="
	${RDEPEND}"

# Some tests fail, mostly those pertaining to ical, perhaps due to requiring network?
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.1-tinfo.patch
	"${FILESDIR}"/${PN}-4.7.1-respect-docdir.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	default
	python_setup
	python_fix_shebang contrib/caldav/calcurse-caldav
}

src_install() {
	# calcurse likes to read the text files uncompressed
	docompress -x /usr/share/doc
	default
}
