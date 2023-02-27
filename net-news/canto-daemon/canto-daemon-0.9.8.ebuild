# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+),threads(+)"
inherit distutils-r1

DESCRIPTION="Daemon part of Canto-NG RSS reader"
HOMEPAGE="https://codezen.org/canto-ng/"
SRC_URI="https://github.com/themoken/canto-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/canto-next-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"
BDEPEND="test? ( ${RDEPEND} )"

python_prepare_all() {
	# Respect libdir during plugins installation
	sed -i -e "s:lib/canto:$(get_libdir)/canto:" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local test_file
	for test_file in tests/*; do
		"${EPYTHON}" "${test_file}" || die "Test ${test_file} failed with ${EPYTHON}"
	done
}
