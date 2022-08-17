# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Asset management for Python web development"
HOMEPAGE="https://github.com/miracle2k/webassets"
SRC_URI="https://github.com/miracle2k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
# ^^ pypi tarball is missing tests

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

# dev-ruby/sass confuses the tests, they expect 'sass' as the reference
# compiler
BDEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		!!dev-ruby/sass
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0-python39.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# webassets wants /usr/bin/babel from babeljs,
	# but we have only one from openbabel
	# ... and we don't have postcss
	sed -i \
		-e 's|\(TestBabel\)|No\1|' \
		-e 's|\(TestAutoprefixer6Filter\)|No\1|' \
		tests/test_filters.py || die

	distutils-r1_python_prepare_all
}
