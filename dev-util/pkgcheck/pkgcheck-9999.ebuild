# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcheck.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore-based QA utility"
HOMEPAGE="https://github.com/pkgcore/pkgcheck"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
IUSE="doc"

if [[ ${PV} == *9999 ]]; then
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]"
else
	RDEPEND="
		>=dev-python/snakeoil-0.8.0[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.10.0[${PYTHON_USEDEP}]"
fi
RDEPEND+=" dev-python/lxml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && esetup.py build_man
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( AUTHORS NEWS.rst )
	esetup.py install_docs \
		--docdir="${ED%/}/usr/share/doc/${PF}" \
		--mandir="${ED%/}/usr/share/man"
	distutils-r1_python_install_all
}

pkg_postinst() {
	pplugincache pkgcheck.plugins
}
