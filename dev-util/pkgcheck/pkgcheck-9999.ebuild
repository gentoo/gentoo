# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgcheck/pkgcheck-9999.ebuild,v 1.5 2015/07/23 06:27:54 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
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

RDEPEND="=sys-apps/pkgcore-9999[${PYTHON_USEDEP}]
	=dev-python/snakeoil-9999[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_setup() {
	# disable snakeoil 2to3 caching...
	unset PY2TO3_CACHEDIR
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( AUTHORS NEWS.rst )
	distutils-r1_python_install_all
}

pkg_postinst() {
	einfo "updating pkgcore plugin cache"
	python_foreach_impl pplugincache pkgcheck.plugins
}
