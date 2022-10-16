# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Signon daemon for libaccounts-glib"
HOMEPAGE="https://gitlab.com/accounts-sso"
SRC_URI="https://gitlab.com/accounts-sso/${PN}/-/archive/VERSION_${PV}/${PN}-VERSION_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-VERSION_${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc test"

# tests are brittle; they all pass when stars align, bug 727666
RESTRICT="test !test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	net-libs/libproxy
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		dev-qt/qthelp:5
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-8.60-buildsystem.patch"
	"${FILESDIR}/${PN}-8.60-consistent-paths.patch" # bug 701142
	"${FILESDIR}/${PN}-8.60-unused-dep.patch" # bug 727346
)

src_prepare() {
	default

	# install docs to correct location
	sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" \
		-i doc/doc.pri || die
	sed -e "/^documentation.path = /c\documentation.path = \$\${INSTALL_PREFIX}/share/doc/${PF}/\$\${TARGET}/" \
		-i lib/plugins/doc/doc.pri || die
	sed -e "/^documentation.path = /c\documentation.path = \$\${INSTALL_PREFIX}/share/doc/${PF}/libsignon-qt/" \
		-i lib/SignOn/doc/doc.pri || die

	use doc || sed -e "/include(\s*doc\/doc.pri\s*)/d" \
		-i signon.pro lib/SignOn/SignOn.pro lib/plugins/plugins.pro || die

	use test || sed -e '/^SUBDIRS/s/tests//' \
		-i signon.pro || die "couldn't disable tests"
}

src_configure() {
	eqmake5 PREFIX="${EPREFIX}"/usr LIBDIR=$(get_libdir)
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
