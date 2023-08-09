# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit python-r1

DESCRIPTION="Unit conversion program"
HOMEPAGE="https://www.gnu.org/software/units/units.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="+units-cur"
REQUIRED_USE="units-cur? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-libs/readline:=
	units-cur? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/requests[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.17-network-sandbox.patch
	"${FILESDIR}"/${PN}-2.20-readerror.patch
)

DOCS=( ChangeLog NEWS README )

src_configure() {
	econf \
		--sharedstatedir="${EPREFIX}"/var/lib \
		ac_cv_path_PYTHON=no
}

src_compile() {
	emake ${PN}
}

src_install() {
	default

	if use units-cur; then
		sed \
			-e "/^outfile/s|'.*'|'/usr/share/units/currency.units'|g" \
			-e 's|^#!|&/usr/bin/python|g' \
			units_cur_inst > units_cur || die
		python_foreach_impl python_doscript units_cur
	fi
}
