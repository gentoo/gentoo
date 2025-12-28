# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN//-/.}
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml.clib/
	https://sourceforge.net/projects/ruamel-yaml-clib/
"
# workaround https://bugs.gentoo.org/898716
S=${WORKDIR}/ruamel_yaml_clib

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

src_unpack() {
	default
	mv "ruamel.yaml.clib-${PV}" ruamel_yaml_clib || die
}

src_configure() {
	cython -f -3 _ruamel_yaml.pyx || die
}
