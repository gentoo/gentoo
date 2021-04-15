# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Agent and tools for managing OpenID Connect tokens on the command line"
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
	"${FILESDIR}"/${PN}-3.3.5_makefile-toolchain-vars.patch
)

src_compile() {
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

	# This file is not compatible with Gentoo and in any case, we generally
	# let the users load such agents themselves.
	rm -f "${ED}"/etc/X11/Xsession.d/91${PN}
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
