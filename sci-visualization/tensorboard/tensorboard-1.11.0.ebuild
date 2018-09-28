# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit python-r1 python-utils-r1

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="https://www.tensorflow.org/"
SRC_URI="https://files.pythonhosted.org/packages/9b/2f/4d788919b1feef04624d63ed6ea45a49d1d1c834199ec50716edb5d310f4/${P}-py3-none-any.whl -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
BDEPEND="app-arch/unzip"
PDEPEND="sci-libs/tensorflow[python,${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}"

src_prepare() {
	rm -rf "${S}/_vendor" || die
	find "${S}" -name '*.py' -exec sed -i -e \
		's/^from tensorboard\._vendor import /import /;
		s/^from tensorboard\._vendor\./from /' {} + || die "failed to unvendor"

	eapply_user
}

src_install() {
	do_install() {
		python_domodule "${S}"
	}
	python_foreach_impl do_install
}
