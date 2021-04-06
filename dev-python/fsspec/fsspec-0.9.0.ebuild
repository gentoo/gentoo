# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

MY_P=filesystem_spec-${PV}

DESCRIPTION="A specification that python filesystems should adhere to"
HOMEPAGE="https://github.com/intake/filesystem_spec/
	https://pypi.org/project/fsspec/"
SRC_URI="
	https://github.com/intake/filesystem_spec/archive/${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-vcs/git
	)"

distutils_enable_tests pytest

src_test() {
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die
	distutils-r1_src_test
}

python_test() {
	# sftp and smb require server started via docker
	pytest -vv \
		--deselect fsspec/tests/test_spec.py::test_find \
		--ignore fsspec/implementations/tests/test_dbfs.py \
		--ignore fsspec/implementations/tests/test_sftp.py \
		--ignore fsspec/implementations/tests/test_smb.py ||
		die "Tests failed with ${EPYTHON}"
}
