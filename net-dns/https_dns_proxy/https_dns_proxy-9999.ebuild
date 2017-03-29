# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="A lightweight DNS-over-HTTPS proxy."
HOMEPAGE="https://github.com/aarond10/https_dns_proxy"
EGIT_REPO_URI="https://github.com/aarond10/${PN}.git"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/libev
	net-dns/c-ares
	>=net-misc/curl-7.53.0[http2,ssl]
	"
RDEPEND="${DEPEND}"

src_install(){
	cmake-utils_src_install
	exeinto /usr/bin
	doexe "${S}_build/https_dns_proxy"
}
