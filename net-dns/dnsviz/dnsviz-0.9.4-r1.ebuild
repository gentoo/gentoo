# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Tool suite for analysis and visualization of DNS and DNSSEC"
HOMEPAGE="
	https://dnsviz.net/
	https://github.com/dnsviz/dnsviz/
	https://pypi.org/project/dnsviz/
"
SRC_URI="
	https://github.com/dnsviz/dnsviz/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/dnspython-1.13[${PYTHON_USEDEP}]
	>=dev-python/m2crypto-0.37.0[${PYTHON_USEDEP}]
	>=dev-python/pygraphviz-1.3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	media-gfx/graphviz
	test? (
		${RDEPEND}
		net-dns/bind
	)
"

python_prepare_all() {
	# Fix the ebuild to use correct FHS/Gentoo policy paths
	sed -i \
		-e "s|share/doc/dnsviz|share/doc/${PF}|g" \
			"${S}"/setup.py \
			|| die

	# skip online tests
	rm tests/*_online.py tests/dnsviz_probe_options.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	eunittest -s tests -p "*.py" || die
}

pkg_postinst() {
	optfeature "Support for pre-deployment testing" net-dns/bind
	optfeature "Support for DNSSEC signatures using GOST algorithm or digest" dev-libs/ghost-engine
}
