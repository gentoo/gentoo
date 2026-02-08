# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ngx_http_auth_pam_module"

inherit nginx-module

DESCRIPTION="NGINX module using PAM for simple HTTP authentication"
HOMEPAGE="https://github.com/sto/ngx_http_auth_pam_module"
SRC_URI="
	https://github.com/sto/ngx_http_auth_pam_module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"

KEYWORDS="amd64 arm64"

DEPEND="sys-libs/pam:="
RDEPEND="${DEPEND}"

src_install() {
	nginx-module_src_install

	dodoc ChangeLog
}
