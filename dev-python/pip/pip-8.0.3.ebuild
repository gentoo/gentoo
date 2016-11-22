# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )
PYTHON_REQ_USE="threads(+)"

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="https://pip.pypa.io/ https://pypi.python.org/pypi/pip/ https://github.com/pypa/pip/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

# Check pip/_vendor/vendor.txt for this
#VENDOR_DEPEND="
#	>=dev-python/distlib-0.2.1[${PYTHON_USEDEP}]
#	>=dev-python/html5lib-0.9999999[${PYTHON_USEDEP}]
#	>=dev-python/six-1.9[${PYTHON_USEDEP}]
#	>=dev-python/colorama-0.3.6[${PYTHON_USEDEP}]
#	>=dev-python/requests-2.9.1-r2[${PYTHON_USEDEP}]
#	>=dev-python/CacheControl-0.11.5[${PYTHON_USEDEP}]
#	>=dev-python/lockfile-0.12.2[${PYTHON_USEDEP}]
#	>=dev-python/progress-1.2[${PYTHON_USEDEP}]
#	>=dev-python/packaging-16.0[${PYTHON_USEDEP}]
#	>=dev-python/retrying-1.3.3[${PYTHON_USEDEP}]
#	>=dev-python/pyparsing-2.0.7[${PYTHON_USEDEP}]
#	virtual/python-ipaddress[${PYTHON_USEDEP}]
#"
# https://github.com/pypa/pip/issues/3057
#RDEPEND="${VENDOR_DEPEND}
#	>=dev-python/setuptools-19.2[${PYTHON_USEDEP}]
#	<dev-python/setuptools-19.4[${PYTHON_USEDEP}]
#"
#DEPEND="${RDEPEND}"

# required test data isn't bundled with the tarball
RESTRICT="test"

#PATCHES=(
#	"${FILESDIR}"/${PN}-6.0.2-disable-version-check.patch
#	"${FILESDIR}"/${PN}-8.0.0-unbundle.patch
#	)

#python_prepare_all() {
#	mv pip/_vendor/__init__.py "${T}" || die
#	rm -r pip/_vendor/* || die
#	mv "${T}"/__init__.py pip/_vendor/__init__.py || die
#
#	distutils-r1_python_prepare_all
#}

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	local DOCS=( AUTHORS.txt docs/*.rst )
	distutils-r1_python_install_all

	COMPLETION="${T}"/completion.tmp

	"${PYTHON}" -m pip completion --bash > "${COMPLETION}" || die
	newbashcomp "${COMPLETION}" ${PN}

	"${PYTHON}" -m pip completion --zsh > "${COMPLETION}" || die
	insinto /usr/share/zsh/site-functions
	newins "${COMPLETION}" _pip
}
