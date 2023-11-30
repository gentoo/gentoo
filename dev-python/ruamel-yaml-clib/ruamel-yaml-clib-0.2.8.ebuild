# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_PN="${PN//-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml.clib/
	https://sourceforge.net/projects/ruamel-yaml-clib/
"
# sdist lacks .pyx files for cythonizing
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz"
# workaround https://bugs.gentoo.org/898716
S=${WORKDIR}/ruamel_yaml_clib

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv sparc x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.7_cython_pointer_types.patch
)

src_unpack() {
	default
	mv "${MY_P}" ruamel_yaml_clib || die
}

src_configure() {
	cython -f -3 _ruamel_yaml.pyx || die
}
