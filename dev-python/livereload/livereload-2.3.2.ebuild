# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/livereload/livereload-2.3.2.ebuild,v 1.2 2015/05/22 03:09:05 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python LiveReload is an awesome tool for web developers"
HOMEPAGE="https://github.com/lepture/python-livereload"
SRC_URI="https://github.com/lepture/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

RDEPEND="www-servers/tornado[${PYTHON_USEDEP}]"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/fix-tests.patch
	)

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( example/. )

	distutils-r1_python_install_all
}
