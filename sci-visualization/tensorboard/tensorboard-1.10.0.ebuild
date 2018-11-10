# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit python-r1 python-utils-r1

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="https://www.tensorflow.org/"
SRC_URI="https://files.pythonhosted.org/packages/c6/17/ecd918a004f297955c30b4fffbea100b1606c225dbf0443264012773c3ff/${P}-py3-none-any.whl -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sci-libs/tensorflow[python,${PYTHON_USEDEP}]
	dev-python/bleach[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	rm -rf "${S}/_vendor" || die
	find "${S}" -name '*.py' -exec sed -i -e \
		's/^from tensorboard\._vendor import /import /;
		s/^from tensorboard\._vendor\./from /' {} + || die "failed to unvendor"

	eapply_user
}

src_install() {
	sed '1i #!/usr/bin/env python' "${S}/main.py" > "${T}/${PN}" || die
	do_install() {
		python_doscript "${T}/${PN}"
		python_domodule "${S}"
	}
	python_foreach_impl do_install
}
