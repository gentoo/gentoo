# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Open source data visualization and analysis for novice and experts."
HOMEPAGE="https://orange.biolab.si/"
SRC_URI="https://github.com/biolab/orange3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/anyqt[${PYTHON_USEDEP}]
	>=dev-python/bottleneck-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/CommonMark-0.5.5[${PYTHON_USEDEP}]
	dev-python/dill[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/joblib-0.9.4[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/keyrings_alt[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
	>=dev-python/pip-9.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyqtgraph-0.10.0[${PYTHON_USEDEP}]
	dev-python/PyQt5[webkit,svg,${PYTHON_USEDEP}]
	dev-python/radon[${PYTHON_USEDEP}]
	dev-python/typing[${PYTHON_USEDEP}]
	>=dev-python/xlrd-0.9.2[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.11.0[${PYTHON_USEDEP}]
	>=sci-libs/scikits_learn-0.18.1[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.9.0[${PYTHON_USEDEP}]"

S="${WORKDIR}/orange3-${PV}"

QA_PREBUILT="/usr/lib*/python*/site-packages/Orange/tests/binary-blob.tab"

python_test() {
	esetup.py test
}
