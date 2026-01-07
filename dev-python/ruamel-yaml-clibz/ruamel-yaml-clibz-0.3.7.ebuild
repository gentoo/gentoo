# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN//-/.}
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )

inherit distutils-r1 pypi

DESCRIPTION="C-based reader/scanner and emitter for dev-python/ruamel-yaml"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml.clibz/
	https://sourceforge.net/projects/ruamel-yaml-clibz/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Technically, upstream depends on setuptools-zig to compile C using Zig,
# but we just use a C compiler.
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

src_configure() {
	cython -f -3 _ruamel_yaml_clibz.pyx || die
}
