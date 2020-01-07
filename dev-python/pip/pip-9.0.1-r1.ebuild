# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )
PYTHON_REQ_USE="threads(+)"

inherit eutils bash-completion-r1 distutils-r1

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="https://pip.pypa.io/ https://pypi.org/project/pip/ https://github.com/pypa/pip/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"

# Check pip/_vendor/vendor.txt for this
#VENDOR_DEPEND="
#	>=dev-python/distlib-0.2.2[${PYTHON_USEDEP}]
#	>=dev-python/html5lib-1.0b8[${PYTHON_USEDEP}]
#	>=dev-python/six-1.10.0${PYTHON_USEDEP}]
#	>=dev-python/colorama-0.3.6[${PYTHON_USEDEP}]
#	>=dev-python/requests-2.9.1-r2[${PYTHON_USEDEP}]
#	>=dev-python/CacheControl-0.11.6[${PYTHON_USEDEP}]
#	>=dev-python/lockfile-0.12.2[${PYTHON_USEDEP}]
#	>=dev-python/progress-1.2[${PYTHON_USEDEP}]
#	>=dev-python/packaging-16.5[${PYTHON_USEDEP}]
#	>=dev-python/retrying-1.3.3[${PYTHON_USEDEP}]
#	>=dev-python/pyparsing-2.1.0[${PYTHON_USEDEP}]
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

PATCHES=(
	"${FILESDIR}/pip-disable-system-install.patch"
	"${FILESDIR}/${PN}-9.0.1-disable-version-check.patch"
)

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
