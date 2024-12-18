# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=OutputCheck-${PV}
DESCRIPTION="A tool for checking the output of console programs inspired by LLVM's FileCheck"
HOMEPAGE="
	https://github.com/stp/OutputCheck/
	https://pypi.org/project/OutputCheck/
"
SRC_URI="
	https://github.com/stp/OutputCheck/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/lit[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-0.4.2-Driver.patch"
	)

	distutils-r1_src_prepare

	# Remove bad tests.
	rm "${S}/tests/invalid-regex-syntax.smt2" || die "failed to remove bad tests"

	# Create RELEASE-VERSION file.
	echo "${PV}" > "${S}/RELEASE-VERSION" || die "failed to write RELEASE-VERSION"
}

python_test() {
	lit --verbose "${S}/tests" || die "running test with ${EPYTHON} failed"
}
