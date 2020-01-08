# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="QML bindings for accounts-qt and signond"
HOMEPAGE="https://accounts-sso.gitlab.io/"
SRC_URI="https://gitlab.com/accounts-sso/${PN}-module/-/archive/VERSION_${PV}/${PN}-module-VERSION_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE="doc test"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	net-libs/accounts-qt
	net-libs/signond
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui:5
		dev-qt/qttest:5
	)
"

# dbus problems
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-no-tests.patch" )

S="${WORKDIR}/${PN}-module-VERSION_${PV}"

src_prepare() {
	default
	sed -e 's/-Werror//' -i common-project-config.pri || die
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install_subtargets
}
