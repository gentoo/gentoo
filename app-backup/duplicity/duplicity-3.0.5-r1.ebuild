# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Secure backup system using gnupg to encrypt data"
HOMEPAGE="https://duplicity.gitlab.io/"
SRC_URI="https://gitlab.com/duplicity/duplicity/-/archive/rel.${PV}/${PN}-rel.${PV}.tar.bz2"
S="${WORKDIR}"/${PN}-rel.${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~x64-macos"
IUSE="s3 test"

COMMON_DEPEND="
	net-libs/librsync
	app-crypt/gnupg
	dev-python/fasteners[${PYTHON_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		|| ( app-arch/par2cmdline app-arch/par2cmdline-turbo )
		dev-python/pexpect[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/paramiko[${PYTHON_USEDEP}]
	s3? ( dev-python/boto3[${PYTHON_USEDEP}] )
"

EPYTEST_DESELECT=(
	# Linting tests (black, pylint, etc); not relevant for us
	testing/test_code.py::CodeTest::test_black
	testing/test_code.py::CodeTest::test_pep8
	testing/test_code.py::CodeTest::test_pylint
)

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.4.0-fix-docs-cmd.patch
	"${FILESDIR}"/${PN}-3.0.5-dont-repeat-standard-paths.patch
	"${FILESDIR}"/${PN}-3.0.5-TotalDestinationSizeChange-concurrency.patch
)

distutils_enable_tests pytest

pkg_postinst() {
	elog "Duplicity has many optional dependencies to support various backends."
	elog "Currently it's up to you to install them as necessary."
}
