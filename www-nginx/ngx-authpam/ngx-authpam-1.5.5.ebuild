# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ngx_http_auth_pam_module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX module using PAM for simple HTTP authentication"
HOMEPAGE="https://github.com/sto/ngx_http_auth_pam_module"
SRC_URI="
	https://github.com/sto/ngx_http_auth_pam_module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

KEYWORDS="~amd64"

DEPEND="sys-libs/pam:="
RDEPEND="${DEPEND}"

src_install() {
	nginx-module_src_install

	dodoc "${NGINX_MOD_S}/ChangeLog"
}
