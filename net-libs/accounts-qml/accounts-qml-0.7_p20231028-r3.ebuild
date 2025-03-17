# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.com/accounts-sso/accounts-qml-module.git/"
	inherit git-r3
else
	COMMIT=05e79ebbbf3784a87f72b7be571070125c10dfe3
	if [[ -n ${COMMIT} ]] ; then
		SRC_URI="https://gitlab.com/accounts-sso/${PN}-module/-/archive/${COMMIT}/${PN}-module-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
		S="${WORKDIR}/${PN}-module-${COMMIT}"
	else
		SRC_URI="
			https://gitlab.com/accounts-sso/${PN}-module/-/archive/VERSION_${PV}/${PN}-module-VERSION_${PV}.tar.bz2
			https://dev.gentoo.org/~asturm/distfiles/${P}-patches-1.tar.xz
		"
		S="${WORKDIR}/${PN}-module-VERSION_${PV}"
	fi
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="QML bindings for accounts-qt and signond"
HOMEPAGE="https://accounts-sso.gitlab.io/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc test"

# dbus problems
RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qtdeclarative:6
	>=net-libs/accounts-qt-1.17-r2
	>=net-libs/signond-8.61-r102
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6[gui] )
"
BDEPEND="
	doc? (
		app-text/doxygen
		dev-qt/qttools:6[assistant,qdoc]
	)
"

DOCS=( README.md )

src_prepare() {
	default
	rm -v doc/html/.gitignore || die
}

src_configure() {
	local myqmakeargs=(
		CONFIG+=no_docs \
		PREFIX="${EPREFIX}"/usr
	)

	eqmake6 "${myqmakeargs[@]}"
}

src_compile() {
	default
	if use doc; then
		$(qt6_get_libdir)/qt6/bin/qdoc doc/accounts-qml-module.qdocconf || die
	fi
}

src_install() {
	local QT_QPA_PLATFORM=offscreen
	emake INSTALL_ROOT="${D}" install_subtargets
	use doc && local HTML_DOCS=( doc )
	einstalldocs
}
