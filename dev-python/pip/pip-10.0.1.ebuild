# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit eutils bash-completion-r1 distutils-r1

DESCRIPTION="Installs python packages -- replacement for easy_install"
HOMEPAGE="https://pip.pypa.io/ https://pypi.org/project/pip/ https://github.com/pypa/pip/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="-vanilla"

# required test data isn't bundled with the tarball
RESTRICT="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-10.0.1-disable-version-check.patch"
	)
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/pip-10.0.1-disable-system-install.patch" )
	fi
	distutils-r1_python_prepare_all
}

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
