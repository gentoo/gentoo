# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1

DESCRIPTION="Read and write audio files' tags in Python"
HOMEPAGE="https://github.com/beetbox/mediafile"
SRC_URI="https://github.com/beetbox/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.45.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
distutils_enable_tests unittest
