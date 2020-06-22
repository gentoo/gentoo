# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic xdg-utils

DESCRIPTION="oidc-agent for managing OpenID Connect tokens on the command line"
HOMEPAGE="https://github.com/indigo-dc/oidc-agent"
SRC_URI="https://github.com/indigo-dc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="app-crypt/libsecret
	dev-libs/libsodium
	net-libs/libmicrohttpd
	sys-libs/libseccomp"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-libs/check )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.1_desktop-category.patch
	"${FILESDIR}"/${PN}-3.3.1_install-perms.patch
	"${FILESDIR}"/${PN}-3.3.1_makefile-toolchain-vars.patch
	"${FILESDIR}"/${PN}-3.3.1_test-suite-buffer-overflows.patch
)

src_compile() {
	# Bug #728840
	append-flags -fcommon

	# Parallel building doesn't work
	emake -j1
}

src_install() {
	emake \
		PREFIX="${ED}" \
		BIN_AFTER_INST_PATH="/usr" \
		INCLUDE_PATH="${ED}"/usr/include \
		LIB_PATH="${ED}"/usr/$(get_libdir) \
		install
}

pkg_postinst() {
	xdg_desktop_database_update

	elog
	elog "You should use oidc-gen to initially generate your account configuration"
	elog "before it can be loaded into oidc-agent using oidc-add. For details, please"
	elog "consult the man page of oidc-gen, or full documentation at"
	elog "    https://indigo-dc.gitbooks.io/oidc-agent/"
	elog
}

pkg_postrm() {
	xdg_desktop_database_update
}
