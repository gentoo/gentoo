# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

# If you get failures from using the latest, check the language used for
# the failing test(s) and roll back the individual fixtures one-by-one.
declare -A TEST_FIXTURES=(
	["embedded-template"]="0.20.0"
	["html"]="0.20.0"
	["javascript"]="0.20.1"
	["json"]="0.20.2"
	["python"]="0.20.4"
	["rust"]="0.20.4"
)

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="
	https://github.com/tree-sitter/py-tree-sitter/
	https://pypi.org/project/tree-sitter/
"
SRC_URI="
	https://github.com/tree-sitter/py-tree-sitter/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
SRC_URI+=" test? ("
for fixture in "${!TEST_FIXTURES[@]}" ; do
	SRC_URI+="
		https://github.com/tree-sitter/tree-sitter-${fixture}/archive/v${TEST_FIXTURES[${fixture}]}.tar.gz
			-> tree-sitter-${fixture}-${TEST_FIXTURES[${fixture}]}.tar.gz
	"
done
SRC_URI+=" )"
S=${WORKDIR}/py-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

DEPEND="dev-libs/tree-sitter:="
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	' 3.12)
"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}"/tree-sitter-0.19.0_p20210506-unbundle.patch
)

src_unpack() {
	default
	rmdir "${S}/tree_sitter/core" || die

	if use test; then
		mkdir "${S}/tests/fixtures" || die
		local fixture
		for fixture in "${!TEST_FIXTURES[@]}" ; do
			mv "tree-sitter-${fixture}-${TEST_FIXTURES[${fixture}]}" "${S}/tests/fixtures/tree-sitter-${fixture}" || die
		done

		# In 0.20.4, this test has a comment saying it's broken, and changing
		# tree-sitter-python (grammar) versions doesn't help, so presumably
		# newer dev-libs/tree-sitter broke it. Revisit on a newer version.
		sed -i -e 's/def test_point_range_captures/def _test_point_range_captures/' "${S}/tests/test_tree_sitter.py" || die
	fi
}

src_test() {
	rm -r tree_sitter || die
	distutils-r1_src_test
}
