# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ncurses"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 linux-info optfeature

DESCRIPTION="CLI curses based monitoring tool"
HOMEPAGE="https://github.com/nicolargo/glances"
SRC_URI="https://github.com/nicolargo/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/orjson[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.4.3[${PYTHON_USEDEP}]
	')
"

# PYTHON_USEDEP omitted on purpose
BDEPEND="doc? ( dev-python/sphinx-rtd-theme )
	test? ( $(python_gen_cond_dep 'dev-python/selenium[${PYTHON_USEDEP}]') )"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS"

PATCHES=(
	"${FILESDIR}/${PN}-4.3.1-disable-update-check.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs --no-autodoc

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

python_test() {
	"${EPYTHON}" -m pytest ./tests/test_core.py || die "tests failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	mv "${ED}/usr/share/doc/${PN}"/* "${ED}/usr/share/doc/${PF}" || die
	rmdir "${ED}/usr/share/doc/${PN}" || die
}

pkg_postinst() {
	optfeature "Autodiscover mode" dev-python/zeroconf
	optfeature "Cloud support" dev-python/requests
	optfeature "Docker monitoring support" dev-python/docker
	optfeature "SVG graph support" dev-python/pygal
	optfeature "IP plugin" dev-python/netifaces
	optfeature "RAID monitoring" dev-python/pymdstat
	optfeature "RAID support" dev-python/pymdstat
	optfeature "SNMP support" dev-python/pysnmp
}
