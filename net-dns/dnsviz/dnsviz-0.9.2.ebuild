# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1 optfeature

DESCRIPTION="Tool suite for analysis and visualization of DNS and DNSSEC"
HOMEPAGE="https://dnsviz.net/"
SRC_URI="https://github.com/dnsviz/dnsviz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( net-dns/bind )"

DEPEND=">=dev-python/dnspython-1.13[${PYTHON_USEDEP}]
	>=dev-python/m2crypto-0.37.0[${PYTHON_USEDEP}]
	>=dev-python/pygraphviz-1.3.1[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}"

python_prepare_all() {
	# Fix the ebuild to use correct FHS/Gentoo policy paths
	sed -i \
		-e "s|share/doc/dnsviz|share/doc/${PF}|g" \
			"${S}"/setup.py \
			|| die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing

	"${EPYTHON}" tests/dnsviz_probe_run_offline.py -v || die
	"${EPYTHON}" tests/dnsviz_print_options.py -v || die
	"${EPYTHON}" tests/dnsviz_print_run.py -v || die
	"${EPYTHON}" tests/dnsviz_graph_options.py -v || die
	"${EPYTHON}" tests/dnsviz_graph_run.py -v || die
	"${EPYTHON}" tests/dnsviz_grok_options.py -v || die
	"${EPYTHON}" tests/dnsviz_grok_run.py -v || die
}

pkg_postinst() {
	elog "Support for extra feature can be get from:"
	optfeature "Support for pre-deployment testing" net-dns/bind
	optfeature "Support for DNSSEC signatures using GOST algorithm or digest" dev-libs/ghost-engine
}
