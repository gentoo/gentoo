# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Tools to supplement packaging Python releases"
HOMEPAGE="https://github.com/jaraco/jaraco.packaging"
SRC_URI="mirror://pypi/${MY_P::1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs '>=dev-python/rst-linker-1.9'
distutils_enable_tests pytest

src_test() {
	# create a pkgutil-style __init__.py in order to fix pytest's
	# determination of package paths
	# https://bugs.gentoo.org/832713
	cat > jaraco/__init__.py <<-EOF || die
		__path__ = __import__('pkgutil').extend_path(__path__, __name__)
	EOF
	distutils-r1_src_test
	rm jaraco/__init__.py || die
}
