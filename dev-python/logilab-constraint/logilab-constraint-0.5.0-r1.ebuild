# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A finite domain constraints solver written in 100% pure Python"
HOMEPAGE="https://www.logilab.org/project/logilab-constraint"
SRC_URI="ftp://ftp.logilab.org/pub/constraint/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE="doc examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/logilab-common[${PYTHON_USEDEP}]"

DOCS=( doc/CONTRIBUTORS )

python_install() {
	# Avoid collisions with dev-python/logilab-common.
	distutils-r1_python_install
	rm -f "${D}$(python_get_sitedir)/logilab/__init__.py" || die
}

python_install_all() {
	use doc && dohtml doc/documentation.html
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
