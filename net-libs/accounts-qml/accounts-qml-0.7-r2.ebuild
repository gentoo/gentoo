# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="QML bindings for accounts-qt and signond"
HOMEPAGE="https://accounts-sso.gitlab.io/"
SRC_URI="https://gitlab.com/accounts-sso/${PN}-module/-/archive/VERSION_${PV}/${PN}-module-VERSION_${PV}.tar.gz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patches-1.tar.xz"
S="${WORKDIR}/${PN}-module-VERSION_${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="doc test"

# dbus problems
RESTRICT="test"

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
BDEPEND="
	doc? (
		app-doc/doxygen
		dev-qt/qdoc:5
	)
"

DOCS=( README.md )

PATCHES=(
	"${WORKDIR}/${P}-patches-1" # bug 849773
	"${FILESDIR}/${P}-gcc12.patch" # bug 870157, pending upstream
)

src_prepare() {
	default
	rm -v .gitignore doc/html/.gitignore || die
}

src_configure() {
	eqmake5 \
		CONFIG+=no_docs \
		PREFIX="${EPREFIX}"/usr
}

src_compile() {
	default
	if use doc; then
		$(qt5_get_bindir)/qdoc doc/accounts-qml-module.qdocconf || die
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install_subtargets
	use doc && local HTML_DOCS=( doc/html )
	einstalldocs
}
