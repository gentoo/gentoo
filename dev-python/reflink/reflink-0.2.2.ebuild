# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper around the reflink system calls"
HOMEPAGE="
	https://gitlab.com/rubdos/pyreflink/
	https://pypi.org/project/reflink/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
# The test suite mounts a btrfs volume on a loopback device.
PROPERTIES="test_privileged"
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${RDEPEND}
	test? ( sys-fs/btrfs-progs )
"

distutils_enable_sphinx docs
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/pytest-runner/d' setup.py || die
	distutils-r1_src_prepare
}

src_test() {
	if [[ ! -c /dev/loop-control ]]; then
		die "Tests require /dev/loop-control"
	fi

	rm -rf reflink || die

	addwrite /dev
	distutils-r1_src_test
}
