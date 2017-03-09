# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3  )

inherit distutils-r1

DESCRIPTION="Core utilities for Python packages"
HOMEPAGE="https://github.com/pypa/packaging https://pypi.python.org/pypi/packaging"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Apache-2.0 BSD-2 )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-python/pyparsing-2.1.10[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-16.8-distutils.patch"
)

python_test() {
	py.test --capture=no --strict -v || die
}

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
