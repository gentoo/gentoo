# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=1.80
inherit perl-module

DESCRIPTION="Reverse-proxy load balancer and webserver"
HOMEPAGE="http://www.danga.com/perlbal/"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/HTTP-Date
	dev-perl/Sys-Syscall
	>=dev-perl/Danga-Socket-1.440.0
	dev-perl/HTTP-Message
	dev-perl/BSD-Resource
	dev-perl/IO-AIO
"
DEPEND="${RDEPEND}"

#SRC_TEST="do" # testing not available on Perlbal yet ;-)

PATCHES=( "${FILESDIR}/${PN}-1.58-Use-saner-name-in-process-listing.patch" )

src_install() {
	perl-module_src_install || die "perl-module_src_install failed"
	cd "${S}"
	dodoc doc/*.txt
	docinto hacking
	dodoc doc/hacking/*.txt
	docinto conf
	dodoc conf/*.{dat,conf}
	keepdir /etc/perlbal
	newinitd "${FILESDIR}"/perlbal_init.d_1.58 perlbal
	newconfd "${FILESDIR}"/perlbal_conf.d_1.58 perlbal
}

pkg_postinst() {
	einfo "Please see the example configuration files located"
	einfo "within /usr/share/doc/${PF}/conf/"
}
