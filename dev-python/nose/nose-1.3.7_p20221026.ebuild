# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

EGIT_COMMIT="8def1b4dcf2ef6b4a34bffdfacea0018a78b06b6"
DESCRIPTION="Unittest extension with automatic test suite discovery and easy test authoring"
HOMEPAGE="
	https://pypi.org/project/nose/
	https://nose.readthedocs.io/en/latest/
	https://github.com/nose-devs/nose
"
SRC_URI="
	https://github.com/arthurzam/nose/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			!hppa? ( dev-python/coverage[${PYTHON_USEDEP}] )
		' python3_{8..10} pypy3)
		$(python_gen_cond_dep '
			dev-python/twisted[${PYTHON_USEDEP}]
		' python3_{8..10})
	)
"

src_prepare() {
	# failing to find configuration file
	sed -e 's/test_cover_options_config_file/_&/' \
		-i unit_tests/test_cover_plugin.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" -m nose -v -a "!network" ||
		die "Tests fail with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install
	use examples && dodoc -r examples
}
