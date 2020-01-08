# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

MY_PN="${PN^^}"
MY_PV="72acfcbffd51da1e77a56517618da68252485ed6"

DESCRIPTION="A graphical web-based front-end for visualizing RRD collected by collectd"
HOMEPAGE="https://github.com/pommi/CGP"
SRC_URI="https://github.com/pommi/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-2.0 GPL-2+ GPL-3 MIT"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-lang/php[json]
	net-analyzer/rrdtool[graph]
	virtual/httpd-php
"

need_httpd_cgi

S="${WORKDIR}/${MY_PN}-${MY_PV}"

DOCS=( "README.md" "doc/CHANGELOG" "doc/nginx.conf" )

src_install() {
	webapp_src_preinst

	einstalldocs

	# Since the docs are already installed, remove them from htdocs
	# The file doc/CHANGELOG is needed, as CGP reads from there it's version
	rm -r .gitignore doc/LICENSE doc/nginx.conf || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst

	einfo "The command shell_exec must not be disabled"
	einfo "through the disable_functions php.ini directive."
	einfo "It must allow execution of the rrdtool program."
	einfo ""
	einfo "An configuration file for www-servers/nginx"
	einfo "has been installed as an example."
}
