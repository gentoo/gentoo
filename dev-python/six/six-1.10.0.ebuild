# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python 2 and 3 compatibility library"
HOMEPAGE="https://bitbucket.org/gutworth/six https://pypi.python.org/pypi/six"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

DEPEND="
	doc? ( dev-python/sphinx )
	test? ( >=dev-python/pytest-2.2.0[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/1.10.0-no-setuptools.patch
	"${FILESDIR}"/1.9.0-mapping.patch
)

if [[ ${PV} != 1.10.0 ]]; then
	# There is no longer a circular dep with setuptools, so please do the following
	# Drop 1.10.0-no-setuptools.patch
	# Add a dependency on dev-python/setuptools[${PYTHON_USEDEP}]
	# Remove pkg_preinst
	# Thanks! - Mike Gilbert (floppym)
	die "Please read the ebuild for notes on this version bump"
fi

python_prepare_all() {
	# https://bitbucket.org/gutworth/six/issues/139/
	sed \
		-e 's:test_assertCountEqual:_&:g' \
		-e 's:test_assertRegex:_&:g' \
		-e 's:test_assertRaisesRegex:_&:g' \
		-i test_six.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C documentation html
}

python_test() {
	py.test -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( documentation/_build/html/ )
	distutils-r1_python_install_all
}

# Remove pkg_preinst in the next version bump
pkg_preinst() {
	# https://bugs.gentoo.org/585146
	cd "${HOME}" || die

	_cleanup() {
		local pyver=$("${PYTHON}" -c "from distutils.sysconfig import get_python_version; print(get_python_version())")
		local egginfo="${ROOT%/}$(python_get_sitedir)/${P}-py${pyver}.egg-info"
		if [[ -d ${egginfo} ]]; then
			echo rm -r "${egginfo}"
			rm -r "${egginfo}" || die "Failed to remove egg-info directory"
		fi
	}
	python_foreach_impl _cleanup
}
