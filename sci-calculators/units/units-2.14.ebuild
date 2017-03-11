# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="xml"
inherit eutils python-r1

DESCRIPTION="Unit conversion program"
HOMEPAGE="https://www.gnu.org/software/units/units.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+units_cur"

DEPEND="
	sys-libs/readline:=
	units_cur? (
		dev-lang/python-exec:2
	)
"
RDEPEND="
	${DEPEND}
	units_cur? (
		dev-python/unidecode[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
"

units_cur_prepare() {
	local UNITS_PYTHON_MAJOR
	UNITS_PYTHON_MAJOR=$(
		UNITS_PYTHON_MAJOR=${EPYTHON/.*}
		shopt -s extglob
		echo ${UNITS_PYTHON_MAJOR/*([[:alpha:]])}
	)
	sed -e "/^outfile/s|'.*'|'/usr/share/units/currency.units'|g" units_cur${UNITS_PYTHON_MAJOR} > units_cur-${EPYTHON}
}

src_prepare() {
	default

	use units_cur && python_foreach_impl units_cur_prepare
}

src_compile() {
	emake HAVE_PYTHON=no
}

units_cur_install() {
	python_newexe units_cur-${EPYTHON} units_cur
}

src_install() {
	emake DESTDIR="${D}" HAVE_PYTHON=no install

	dodoc ChangeLog NEWS README

	use units_cur && python_foreach_impl units_cur_install
}
