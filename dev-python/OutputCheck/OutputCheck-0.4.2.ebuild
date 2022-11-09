# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A tool for checking the output of console programs inspired by LLVM's FileCheck"
HOMEPAGE="https://github.com/stp/OutputCheck/"
SRC_URI="https://github.com/stp/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/lit[${PYTHON_USEDEP}] )"

src_prepare() {
	distutils-r1_src_prepare

	# Remove bad tests.
	rm "${S}"/tests/invalid-regex-syntax.smt2 ||
		die "failed to remove bad tests"

	# Create RELEASE-VERSION file.
	echo ${PV} > "${S}"/RELEASE-VERSION ||
		die "failed to write RELEASE-VERSION"
}

python_test() {
	lit "${S}"/tests || die "running test with ${EPYTHON} failed"
}
