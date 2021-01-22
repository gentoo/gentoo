# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit distutils-r1 optfeature

DESCRIPTION="Tool suite for analysis and visualization of DNS and DNSSEC"
HOMEPAGE="https://dnsviz.net/"
SRC_URI="https://github.com/dnsviz/dnsviz/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/dnspython-1.13[${PYTHON_USEDEP}]
	>=dev-python/m2crypto-0.37.0[${PYTHON_USEDEP}]
	>=dev-python/pygraphviz-1.3.1[${PYTHON_USEDEP}]"

RDEPEND="
	${DEPEND}"

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

	"${EPYTHON}" tests/offline_tests.py -v || die

	# No need to pull in net-dns/bind for this small test
	if hash named-checkconf &>/dev/null ; then
		"${EPYTHON}" tests/local_probe_tests.py -v || die
	else
		einfo "Skipping local_probe_tests -- named-checkconf not found!"
	fi
}

pkg_postinst() {
	elog "Support for extra feature can be get from:"
	optfeature "Support for pre-deployment testing" net-dns/bind
	optfeature "Support for DNSSEC signatures using GOST algorithm or digest" dev-libs/ghost-engine
}
