# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

# no tags on github, no tests on PyPI
MY_PV=1d8aca73a72a4615b165602af9890517444e45d9

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python Japanese character interconverter"
HOMEPAGE="
	https://pypi.org/project/jaconv/
	https://github.com/ikegami-yukino/jaconv
"
SRC_URI="
	https://github.com/ikegami-yukino/jaconv/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/eli-schwartz/jaconv/commit/4f4160d33267ee7b6ff7386cdcdc6064a315b82a.patch?full_index=1
		-> ${P}-nose-to-pytest.patch
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/ikegami-yukino/jaconv/pull/36
	"${DISTDIR}"/${P}-nose-to-pytest.patch
)

src_prepare() {
	default
	# tries to add README as data to install to sys.prefix
	sed -i '/data_files/d' setup.py
}
