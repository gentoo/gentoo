# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Qt5 bindings for libaccounts-glib"
HOMEPAGE="https://accounts-sso.gitlab.io/"
SRC_URI="https://gitlab.com/accounts-sso/lib${PN}/repository/VERSION_${PV}/archive.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="doc test"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	>=net-libs/libaccounts-glib-1.23:=
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

# dbus problems
RESTRICT="test"

S="${WORKDIR}/lib${PN}-VERSION_${PV}-525ec684cfa8d234f797d7e49e21c476eea04d8e"

src_prepare() {
	default

	sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" \
		-i doc/doc.pri || die
	if ! use doc; then
		sed -e "/include( doc\/doc.pri )/d" -i ${PN}.pro || die
	fi
	if ! use test; then
		sed -e '/^SUBDIRS/s/tests//' \
			-i accounts-qt.pro || die "couldn't disable tests"
	fi
}

src_configure() {
	eqmake5 LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
