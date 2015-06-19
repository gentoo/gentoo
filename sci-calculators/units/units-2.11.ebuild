# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/units/units-2.11.ebuild,v 1.12 2015/05/28 15:14:19 jmorgan Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} )
PYTHON_REQ_USE="xml"
inherit eutils python-r1

DESCRIPTION="Unit conversion program"
HOMEPAGE="http://www.gnu.org/software/units/units.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="+units_cur"

DEPEND="
	>=sys-libs/readline-4.1-r2
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

DOCS=( ChangeLog NEWS README )

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

	use units_cur && python_foreach_impl units_cur_install
}
