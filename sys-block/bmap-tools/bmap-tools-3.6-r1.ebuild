# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Flashing tool using block maps and sparse files"
HOMEPAGE="https://github.com/intel/bmap-tools"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/intel/bmap-tools.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/intel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/six[${PYTHON_USEDEP}] )
"

RDEPEND="
	app-arch/pigz
	app-arch/lzop
	app-arch/lz4
	app-arch/pbzip2
	app-arch/xz-utils
	app-arch/bzip2
	app-arch/gzip
	app-arch/tar
"

DOCS=( "${S}/docs/README" )

PATCHES=(
	"${FILESDIR}"/${P}-unittest-mock.patch
	"${FILESDIR}"/${P}-mock-import-pattern.patch
)

# tests are hanging using default below
RESTRICT="!test? ( test )"

EPYTEST_DESELECT=(
	# remaining tests involve way too much file I/O
	tests/test_api_base.py	# too many open files
	tests/test_bmap_helpers.py::TestBmapHelpers::test_get_file_system_type_symlink	# depends on backports.tempfile
	tests/test_bmap_helpers.py::TestBmapHelpers::test_is_zfs_configuration_compatible_unreadable_file	# fails
)

distutils_enable_tests pytest
