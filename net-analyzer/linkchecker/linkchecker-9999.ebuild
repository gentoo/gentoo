# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite?"

EGIT_REPO_URI="https://github.com/linkcheck/linkchecker.git"
inherit bash-completion-r1 distutils-r1 eutils git-r3

DESCRIPTION="Check websites for broken links"
HOMEPAGE="https://github.com/linkcheck/linkchecker"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="sqlite"

RDEPEND="
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4[${PYTHON_USEDEP}]
	virtual/python-dnspython[${PYTHON_USEDEP}]
"
DEPEND=""

RESTRICT="test"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-9.3-bash-completion.patch"
	)

	distutils-r1_python_prepare_all
}

python_install_all() {
	DOCS=(
		doc/changelog.txt
		doc/development.mdwn
		doc/python3.txt
		doc/upgrading.txt
	)
	distutils-r1_python_install_all

	rm "${ED}"/usr/share/applications/linkchecker.desktop || die

	newbashcomp config/linkchecker-completion ${PN}
}

pkg_postinst() {
	optfeature "bash-completion support" dev-python/argcomplete[${PYTHON_USEDEP}]
	optfeature "Virus scanning" app-antivirus/clamav
	optfeature "Geo IP support" dev-python/geoip-python[${PYTHON_USEDEP}]
}
