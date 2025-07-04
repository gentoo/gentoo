# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Tool suite for analysis and visualization of DNS and DNSSEC"
HOMEPAGE="
	https://dnsviz.net/
	https://github.com/dnsviz/dnsviz/
	https://pypi.org/project/dnsviz/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/dnspython-1.13[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.0[${PYTHON_USEDEP}]
	>=dev-python/pygraphviz-1.3.1[${PYTHON_USEDEP}]
"
BDEPEND="
	media-gfx/graphviz
	test? (
		${RDEPEND}
		net-dns/bind
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# Fix the ebuild to use correct FHS/Gentoo policy paths
	sed -i \
		-e "s|share/doc/dnsviz|share/doc/${PF}|g" \
			"${S}"/setup.py \
			|| die

	distutils-r1_python_prepare_all
}

python_test() {
	EPYTEST_DESELECT=(
		# Needs network
		tests/test_61_dnsviz_probe_options.py::DNSVizProbeOptionsTestCase::test_authoritative_option
		tests/test_61_dnsviz_probe_options.py::DNSVizProbeOptionsTestCase::test_recursive_aggregation
		tests/test_61_dnsviz_probe_options.py::DNSVizProbeOptionsTestCase::test_recursive_option
	)

	epytest -k "not _online"
}

pkg_postinst() {
	optfeature "Support for pre-deployment testing" net-dns/bind
	optfeature "Support for DNSSEC signatures using GOST algorithm or digest" dev-libs/gost-engine
}
