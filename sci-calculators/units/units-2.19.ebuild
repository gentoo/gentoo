# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit python-single-r1

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
		${PYTHON_DEPS}
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.17-network-sandbox.patch
)

pkg_setup() {
	use units_cur && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		--sharedstatedir="${EROOT}/var/lib" \
		ac_cv_path_PYTHON=no
}

src_compile() {
	emake ${PN}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc ChangeLog NEWS README

	# we're intentionally delaying this since 'make install' would
	# get confused if we shove 'units_cur' there, and there is no real
	# need to add more complexity for it
	if use units_cur; then
		sed \
			-e "/^outfile/s|'.*'|'/usr/share/units/currency.units'|g" \
			-e 's|^#!|&/usr/bin/python|g' \
			units_cur_inst > units_cur || die
		python_fix_shebang units_cur
		python_doscript units_cur
	fi
}
