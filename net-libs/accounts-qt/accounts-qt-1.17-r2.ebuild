# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.com/accounts-sso/lib${PN}.git/"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/accounts-sso/lib${PN}/-/archive/VERSION_${PV}/lib${PN}-VERSION_${PV}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/lib${PN}-VERSION_${PV}"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Qt bindings for libaccounts-glib"
HOMEPAGE="https://accounts-sso.gitlab.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc test"

# dbus problems
RESTRICT="test"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtbase:6[xml]
	>=net-libs/libaccounts-glib-1.23:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-qt/qttools:6[assistant]
	)
"

PATCHES=( "${FILESDIR}/${PN}-1.16-libdir.patch" )

src_prepare() {
	default

	sed -e "s|share/doc/\$\${PROJECT_NAME}|share/doc/${PF}|" \
		-i doc/doc.pri || die
	sed -e "/QHG_LOCATION/s|qhelpgenerator|$(qt6_get_libexecdir)/&|" \
		-i doc/doxy.conf || die
	if ! use doc; then
		sed -e "/include( doc\/doc.pri )/d" -i ${PN}.pro || die
	fi
	if ! use test; then
		sed -e '/^SUBDIRS/s/tests//' \
			-i accounts-qt.pro || die "couldn't disable tests"
	fi
}

src_configure() {
	eqmake6 PREFIX="${EPREFIX}"/usr LIBDIR=$(get_libdir)
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
