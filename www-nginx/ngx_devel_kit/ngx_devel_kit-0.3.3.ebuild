# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="An NGINX module that adds generic tools for third-party modules"
HOMEPAGE="https://github.com/vision5/ngx_devel_kit"

SRC_URI="
	https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD"

SLOT=0

inherit nginx-module

src_configure() {
	append-cflags -DNDK_ALL
	nginx-module_src_configure
}

src_install() {
	nginx-module_src_install
	cd "${NGINX_MOD_S}" || die "cd failed"
	# Install ngx_devel_kit's headers for use by other modules.
	insinto /usr/include/nginx/modules
	find objs src -maxdepth 1 -type f -name '*.h' -print0 | xargs -0 doins || die "doins failed"
}
