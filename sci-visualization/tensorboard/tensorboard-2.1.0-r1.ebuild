# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit python-r1

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="https://www.tensorflow.org/"
SRC_URI="https://files.pythonhosted.org/packages/py3/${PN::1}/${PN}/${P}-py3-none-any.whl -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	dev-python/bleach[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.6.3[${PYTHON_USEDEP}]
	>=dev-python/google-auth-oauthlib-0.4.1[${PYTHON_USEDEP}]
	dev-python/grpcio[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	>=sci-libs/scipy-1.4.1[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
BDEPEND="app-arch/unzip
	${PYTHON_DEPS}"
PDEPEND="sci-libs/tensorflow[python,${PYTHON_USEDEP}]"

S="${WORKDIR}"

src_prepare() {
	eapply_user

	rm -rf "${S}/${PN}/_vendor/bleach" || die
	rm -rf "${S}/${PN}/_vendor/html5lib" || die
	sed -i -e '/_vendor.bleach/d' -e '/_vendor.html5lib/d' "${S}/${P}.dist-info/RECORD" || die "failed to unvendor"

	find "${S}/${PN}" -name '*.py' -exec sed -i \
		-e 's/^from tensorboard\._vendor import html5lib/import html5lib/' \
		-e 's/^from tensorboard\._vendor import bleach/import bleach/' \
		-e 's/^from tensorboard\._vendor\.html5lib/from html5lib/' \
		-e 's/^from tensorboard\._vendor\.bleach/from bleach/' \
		{} + || die "failed to unvendor"
}

src_install() {
	do_install() {
		python_domodule "${PN}"
		python_domodule "${P}.dist-info"
	}
	python_foreach_impl do_install
}
