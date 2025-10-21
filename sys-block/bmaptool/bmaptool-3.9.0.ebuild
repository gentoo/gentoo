# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.14 tests fail for tests/test_api_base.py::TestCreateCopy::test
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 optfeature

DESCRIPTION="The better dd for embedded projects, based on block maps"
HOMEPAGE="https://github.com/yoctoproject/bmaptool"
SRC_URI="
	https://github.com/yoctoproject/bmaptool/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# pyproject.tom'l isnt the ultimate truth for dependencies.
# Check the Debian control file and rpm spec for a better idea.
RDEPEND="
	app-arch/tar
"
BDEPEND="
	test? (
		app-arch/bzip2
		app-arch/gzip
		app-arch/lz4
		app-arch/lzop
		app-arch/pbzip2
		app-arch/pigz
		app-arch/unzip
		app-arch/xz-utils
		app-arch/zstd
		dev-python/gpgmepy[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md )

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Use reference implementation where alternative implementation would already be preferred
	sed -e '/decompressor =/ { s/"gzip"/"gzip-reference"/; s/"bzip2"/"bzip2-reference"/ }' \
		-i src/bmaptool/TransRead.py || die
}

src_install() {
	distutils-r1_src_install

	doman docs/man1/bmaptool.1
}

pkg_postinst() {
	optfeature "ssh:// support" virtual/ssh
	optfeature "password-based SSH authentication" net-misc/sshpass
	optfeature_header "Support for on-the-fly decompression:"
	optfeature "'.gz', '.gzip', '.tar.gz' and '.tgz'" app-arch/gzip app-arch/pigz
	optfeature "'.bz2', 'tar.bz2', '.tbz2', '.tbz', and '.tb2'" app-arch/bzip2 app-arch/pbzip2
	optfeature "'.xz', '.tar.xz', '.txz'" app-arch/xz-utils
	optfeature "'.lzo', 'tar.lzo', '.tzo'" app-arch/lzop
	optfeature "'.lz4', 'tar.lz4', '.tlz4'" app-arch/lz4
	optfeature "'.zst', 'tar.zst', '.tzst'" app-arch/zstd
	optfeature "'.zip'" app-arch/unzip
}
