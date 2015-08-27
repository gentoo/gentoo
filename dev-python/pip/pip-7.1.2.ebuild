# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="https://pip.pypa.io/ https://pypi.python.org/pypi/pip/ https://github.com/pypa/pip/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

# Check pip/_vendor/vendor.txt for this
VENDOR_DEPEND="
	>=dev-python/distlib-0.2.1[${PYTHON_USEDEP}]
	>=dev-python/html5lib-0.999999[${PYTHON_USEDEP}]
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/CacheControl-0.11.5[${PYTHON_USEDEP}]
	>=dev-python/lockfile-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/progress-1.2[${PYTHON_USEDEP}]
	>=dev-python/ipaddress-1.0.14[${PYTHON_USEDEP}]
	>=dev-python/packaging-15.3[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.3.3[${PYTHON_USEDEP}]
"
RDEPEND="${VENDOR_DEPEND}
	>=dev-python/setuptools-18.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

# required test data isn't bundled with the tarball
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.2-disable-version-check.patch
	"${FILESDIR}"/${P}-unbundle.patch
	)

python_prepare_all() {
	mv pip/_vendor/__init__.py "${T}" || die
	rm -r pip/_vendor/* || die
	mv "${T}"/__init__.py pip/_vendor/__init__.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	local DOCS=( AUTHORS.txt docs/*.rst )
	distutils-r1_python_install_all

	COMPLETION="${T}"/completion.tmp

	${EPYTHON} pip/__init__.py completion --bash > "${COMPLETION}" || die
	newbashcomp "${COMPLETION}" ${PN}

	${EPYTHON} pip/__init__.py completion --zsh > "${COMPLETION}" || die
	insinto /usr/share/zsh/site-functions
	newins "${COMPLETION}" _pip
}
