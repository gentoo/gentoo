# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

TYPESHED_PV="$(ver_cut 1-2).0"
TYPESHED_P="typeshed-jedi_v${TYPESHED_PV}"

DESCRIPTION="Autocompletion library for Python"
HOMEPAGE="https://github.com/davidhalter/jedi"
SRC_URI="https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/davidhalter/typeshed/archive/${TYPESHED_P#typeshed-}.tar.gz -> ${TYPESHED_P}.tar.gz"

LICENSE="MIT
	test? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/parso-0.5.0[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT+=" !test? ( test )"

PATCHES=(
	# mostly pulled from upstream git, except the patch for
	# test/test_evaluate/test_sys_path.py
	"${FILESDIR}/jedi-0.15.1-tests.patch"
)

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	# upstream includes this as a submodule ...
	rmdir "${S}/jedi/third_party/typeshed" || die
	mv "${WORKDIR}/${TYPESHED_P}" \
		"${S}/jedi/third_party/typeshed" || die

	# don't run doctests, don't depend on colorama
	sed -i "s:'docopt',:: ; s:'colorama',::" setup.py || die
	sed -i "s: --doctest-modules::" pytest.ini || die

	# speed tests are fragile
	rm test/test_speed.py || die

	# 'path' completion test does not account for 'path' being a valid
	# package (i.e. dev-python/path-py)
	# https://github.com/davidhalter/jedi/issues/1210
	sed -i -e '/path.*not in/d' test/test_evaluate/test_imports.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# at this point fixing tests on python2 isn't worth the effort...
	if ! python_is_python3; then
		ewarn "Skipping tests for ${EPYTHON}"
		return 0
	fi

	pytest -vv || die "Tests fail with ${EPYTHON}"
}
