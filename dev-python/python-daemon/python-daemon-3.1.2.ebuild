# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Library to implement a well-behaved Unix daemon process"
HOMEPAGE="
	https://pagure.io/python-daemon/
	https://pypi.org/project/python-daemon/
"

# build system and tests use GPL-3.0+ but none of these files are installed
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ~ppc ppc64 ~sparc x86"

RDEPEND="
	>=dev-python/lockfile-0.10[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# overengineered logic with NIH deps
	rm setup.py || die
	cat > setup.cfg <<-EOF || die
		[metadata]
		version = ${PV}
		description = ${DESCRIPTION}
		maintainer =
		long_description =
		exclude = doc
	EOF

	# tests for their overengineered setup
	rm test/test_{setup,util_metadata}.py || die
}
