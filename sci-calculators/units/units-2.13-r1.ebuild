# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="xml"

inherit autotools python-r1

DESCRIPTION="Unit conversion program"
HOMEPAGE="https://www.gnu.org/software/units/units.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+units_cur"
REQUIRED_USE="units_cur? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-libs/readline:0=
	units_cur? (
		${PYTHON_DEPS}
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/future[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-python.patch" )

src_prepare() {
	default
	sed -e "/^outfile/s|'.*'|'${EPREFIX}/usr/share/units/currency.units'|g" \
		-i units_cur3 || die

	eautoreconf
}

src_install() {
	default
	use units_cur && python_foreach_impl python_newscript units_cur{3,}
}
