# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite?"

inherit bash-completion-r1 distutils-r1 eutils multilib

MY_PN="${PN/linkchecker/LinkChecker}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Check websites for broken links"
HOMEPAGE="https://wummel.github.com/linkchecker/ https://pypi.python.org/pypi/linkchecker/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos ~x64-solaris"
IUSE="gnome sqlite X"

RDEPEND="
	virtual/python-dnspython[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.1[${PYTHON_USEDEP}]
	gnome? ( dev-python/pygtk:2[${PYTHON_USEDEP}] )
	X? (
		dev-python/PyQt4[X,help,${PYTHON_USEDEP}]
		dev-python/qscintilla-python[${PYTHON_USEDEP}]
		)"
DEPEND="
	X? (
		dev-qt/qthelp:4
		dev-python/markdown2[${PYTHON_USEDEP}]
		)"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-9.2-unbundle.patch
		"${FILESDIR}"/${P}-bash-completion.patch
		"${FILESDIR}"/${P}-desktop.patch
		)

	emake -C doc/html

	distutils-r1_python_prepare_all
}

python_install_all() {
	DOCS=(
		doc/upgrading.txt
		doc/python3.txt
		doc/changelog.txt
		doc/development.txt
	)
	distutils-r1_python_install_all
	if ! use X; then
		delete_gui() {
				rm -rf \
					"${ED}"/usr/bin/linkchecker-gui* \
					"${ED}"/$(python_get_sitedir)/linkcheck/gui* || die
		}
		python_foreach_impl delete_gui
		rm -f "${ED}"/usr/share/applications/linkchecker*.desktop || die
	fi

	rm -f "${ED}"/usr/share/applications/linkchecker.desktop || die

	newicon doc/html/logo64x64.png ${PN}.png

	docinto html
	dodoc doc/html/*
	newbashcomp config/linkchecker-completion ${PN}
	optfeature "bash-completion support" dev-python/argcomplete[${PYTHON_USEDEP}]
	optfeature "Virus scanning" app-antivirus/clamav
	optfeature "Geo IP support" dev-python/geoip-python[${PYTHON_USEDEP}]
}
