# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit python-r1 pypi

DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="https://www.tensorflow.org/"
SRC_URI="$(pypi_wheel_url --unpack)"
S=${WORKDIR}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
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
	>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
"
BDEPEND="
	app-arch/unzip
	${PYTHON_DEPS}
"
PDEPEND="
	=sci-libs/tensorflow-2.15*[python,${PYTHON_USEDEP}]
"

src_prepare() {
	eapply_user

	sed -i -e '/_vendor.__init__/d' -e '/_vendor.bleach/d' -e '/_vendor.html5lib/d' -e '/_vendor.webencodings/d' \
		"${S}/${P}.dist-info/RECORD" || die "failed to unvendor"
	grep -q "_vendor" "${S}/${P}.dist-info/RECORD" && die "More vendored deps found"

	find "${S}/${PN}" -name '*.py' -exec sed -i \
		-e 's/^from tensorboard\._vendor import /import /' \
		-e 's/^from tensorboard\._vendor\./from /' \
		{} + || die "failed to unvendor"

	rm -rf "${S}/${PN}/_vendor" || die

	sed -i -e '/tensorboard-plugin-/d' "${S}/${P}.dist-info/METADATA" || die "failed to remove plugin deps"
	sed -i -e '/tensorboard-data-server/d' "${S}/${P}.dist-info/METADATA" || die "failed to remove data-server deps"
	sed -i -e 's/google-auth-oauthlib.*$/google-auth-oauthlib/' "${S}/${P}.dist-info/METADATA" \
		|| die "failed to relax oauth deps"
	sed -i -e 's/protobuf.*$/protobuf/' "${S}/${P}.dist-info/METADATA" \
		|| die "failed to relax protobuf deps"
}

src_install() {
	do_install() {
		python_domodule "${PN}"
		python_domodule "${P}.dist-info"
	}
	python_foreach_impl do_install
}
