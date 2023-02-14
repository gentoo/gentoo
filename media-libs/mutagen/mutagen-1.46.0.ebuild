# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Audio metadata tag reader and writer implemented in pure Python"
HOMEPAGE="
	https://github.com/quodlibet/mutagen/
	https://pypi.org/project/mutagen/
"
SRC_URI="
	https://github.com/quodlibet/mutagen/releases/download/release-${PV}/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/eyeD3[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		media-libs/flac[ogg]
	)
"

DOCS=( NEWS README.rst )

PATCHES=(
	"${FILESDIR}"/${PN}-1.46.0-sphinx-6.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
