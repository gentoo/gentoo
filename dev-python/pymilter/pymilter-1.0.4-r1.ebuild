# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS="no"

inherit distutils-r1

DESCRIPTION="Python interface to sendmail milter API"
HOMEPAGE="https://github.com/sdgathman/pymilter"
SRC_URI="https://github.com/sdgathman/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )"

DEPEND="${CDEPEND}
	test? ( $(python_gen_impl_dep sqlite) )"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}-${P}"

python_test() {
	"${EPYTHON}" -m unittest discover -v || die
}
