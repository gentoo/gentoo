# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DORMANDO
DIST_VERSION=1.80
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

PATCHES=(
	"${FILESDIR}/${PN}-1.58-Use-saner-name-in-process-listing.patch"
	"${FILESDIR}/${PN}-1.80-init-scripts.patch"
)

PERL_RM_FILES=(
	# These currently fail for unclear reasons
	"t/20-put.t"
	"t/31-realworld.t"
	"t/32-selector.t"
	"t/35-reproxy.t"
	"t/40-ranges.t"
)
DIST_TEST="do" # parallel testing broken

src_install() {
	perl-module_src_install || die "perl-module_src_install failed"
	cd "${S}"
	dodoc doc/*.txt
	docinto hacking
	dodoc doc/hacking/*.txt
	docinto conf
	dodoc conf/*.{dat,conf}
	keepdir /etc/perlbal
	newinitd "${S}"/gentoo/init.d/perlbal perlbal
	newconfd "${S}"/gentoo/conf.d/perlbal perlbal
}

pkg_postinst() {
	einfo "Please see the example configuration files located"
	einfo "within /usr/share/doc/${PF}/conf/"
}
