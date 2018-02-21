# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
IUSE="gnome sqlite"

RDEPEND="
	virtual/python-dnspython[${PYTHON_USEDEP}]
	gnome? ( dev-python/pygtk:2[${PYTHON_USEDEP}] )
"
DEPEND=""

RESTRICT="test"

python_prepare_all() {
	local PATCHES=( "${FILESDIR}"/${PN}-9.3-bash-completion.patch )

	distutils-r1_python_prepare_all
}

python_install_all() {
	DOCS=(
		doc/upgrading.txt
		doc/python3.txt
		doc/changelog.txt
		doc/development.mdwn
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
