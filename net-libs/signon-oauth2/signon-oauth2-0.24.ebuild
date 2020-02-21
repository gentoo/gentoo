# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=signon-plugin-oauth2
MY_PV=VERSION_${PV}
inherit qmake-utils

DESCRIPTION="OAuth2 plugin for Signon daemon"
HOMEPAGE="https://gitlab.com/accounts-sso/signon-plugin-oauth2"
SRC_URI="https://gitlab.com/accounts-sso/${MY_PN}/-/archive/${MY_PV}/${MY_PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	net-libs/signond
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${P}-disable-examples.patch"
	"${FILESDIR}/${P}-dont-install-tests.patch"
)

src_prepare() {
	default
	sed -i -e '/QMAKE_CXXFLAGS.*Werror/s/^/#DONT /' common-project-config.pri ||
		die "failed to disable -Werror"
	if ! use test; then
		sed -i -e '/^SUBDIRS/s/tests//' signon-oauth2.pro ||
			die "Failed to disable tests"
	fi
}

src_configure() {
	eqmake5 \
		LIBDIR=/usr/$(get_libdir)
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
