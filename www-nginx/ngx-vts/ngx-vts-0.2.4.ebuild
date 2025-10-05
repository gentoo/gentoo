# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-module-vts"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX virtual host traffic status module"
HOMEPAGE="https://github.com/vozlt/nginx-module-vts"
SRC_URI="
	https://github.com/vozlt/nginx-module-vts/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	nginx-module_src_install

	dodoc "${NGINX_MOD_S}/CHANGELOG.md"
	# Install the HTML status pages.
	insinto usr/share/"${PN}"
	doins "${NGINX_MOD_S}"/share/*.html
}

pkg_postinst() {
	nginx-module_pkg_postinst

	elog "The HTML status pages have been saved to ${EPREFIX}/usr/share/${PN}."
	elog "Copy or symlink/hardlink them to your server directory and"
	elog "edit to your pleasure."
}
