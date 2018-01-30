# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite?"

inherit bash-completion-r1 distutils-r1 eutils

DESCRIPTION="Check websites for broken links"
HOMEPAGE="https://github.com/linkcheck/linkchecker"
SRC_URI="https://github.com/linkcheck/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-solaris"
IUSE="gnome sqlite"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	virtual/python-dnspython[${PYTHON_USEDEP}]
	gnome? ( dev-python/pygtk:2[${PYTHON_USEDEP}] )
"
DEPEND=""

RESTRICT="test"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-9.2-unbundle.patch"
		"${FILESDIR}/${PN}-9.3-bash-completion.patch"
		"${FILESDIR}/${PN}-9.3.1-build-fix.patch"
		"${FILESDIR}/${PN}-9.3.1-requests.patch"
	)

	distutils-r1_python_prepare_all
}

python_install_all() {
	delete_gui() {
		rm -rf \
			"${ED}"/usr/bin/linkchecker-gui* \
			"${ED}"/$(python_get_sitedir)/linkcheck/gui* || die
	}

	DOCS=(
		doc/upgrading.txt
		doc/python3.txt
		doc/changelog.txt
		doc/development.txt
	)
	distutils-r1_python_install_all

	python_foreach_impl delete_gui
	rm -f "${ED}"/usr/share/applications/linkchecker*.desktop || die

	newicon doc/html/logo64x64.png ${PN}.png

	docinto html
	dodoc doc/html/*
	newbashcomp config/linkchecker-completion ${PN}
}

pkg_postinst() {
	optfeature "bash-completion support" dev-python/argcomplete[${PYTHON_USEDEP}]
	optfeature "Virus scanning" app-antivirus/clamav
	optfeature "Geo IP support" dev-python/geoip-python[${PYTHON_USEDEP}]
}
