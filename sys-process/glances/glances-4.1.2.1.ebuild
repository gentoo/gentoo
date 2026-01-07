# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="amd64 arm arm64 ppc64 x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/orjson[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.4.3[${PYTHON_USEDEP}]
	')
"

# PYTHON_USEDEP omitted on purpose
BDEPEND="doc? ( dev-python/sphinx-rtd-theme )"

CONFIG_CHECK="~TASK_IO_ACCOUNTING ~TASK_DELAY_ACCT ~TASKSTATS"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.6-disable-update-check.patch"
	"${FILESDIR}/${PN}-4.0.6-doc-install-path.patch"
)

distutils_enable_tests unittest
distutils_enable_sphinx docs --no-autodoc

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# the version is tagged 4.1.2.1 but upstream seemingly forgot to
	# update the version, hack around it for now
	sed -i "/__version__/s/4.1.2/${PV}/" glances/__init__.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" unittest-core.py || die "tests failed with ${EPYTHON}"
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
