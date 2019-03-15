# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1

DESCRIPTION="Diff JSON and JSON-like structures in Python."
HOMEPAGE="https://pypi.org/project/jsondiff/ https://github.com/ZoomerAnalytics/jsondiff"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# Rename to avoid file-collisions with dev-python/jsonpatch
	sed -i \
		-e "s#'jsondiff=#'json-diff=#" \
		setup.py || die "sed failed"

	distutils-r1_python_prepare_all
}

