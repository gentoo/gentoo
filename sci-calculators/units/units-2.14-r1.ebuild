# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="xml"
inherit eutils python-single-r1

DESCRIPTION="Unit conversion program"
HOMEPAGE="https://www.gnu.org/software/units/units.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+units_cur"
REQUIRED_USE="units_cur? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-libs/readline:=
	units_cur? (
		dev-python/unidecode[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"
DEPEND=${RDEPEND}

pkg_setup() {
	use units_cur && python-single-r1_pkg_setup
}

src_configure() {
	econf ac_cv_path_PYTHON=no
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog NEWS README

	# we're intentionally delaying this since 'make install' would
	# get confused if we shove 'units_cur' there, and there is no real
	# need to add more complexity for it
	if use units_cur; then
		local pyver
		python_is_python3 && pyver=3 || pyver=2
		sed -e "/^outfile/s|'.*'|'/usr/share/units/currency.units'|g" \
			"units_cur${pyver}" > units_cur || die
		python_doscript units_cur
	fi
}
