# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/eiwic/eiwic-1.1.4.ebuild,v 1.7 2014/09/21 12:47:50 angelos Exp $

EAPI=4
WANT_AUTOMAKE=1.10
inherit autotools eutils multilib

DESCRIPTION="A modular IRC bot written in C"
HOMEPAGE="https://github.com/lordi/Eiwic"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc ipv6"

DOCS="AUTHORS ChangeLog README NEWS TODO sample.conf"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.3-ldflags.patch

	sed -i \
		-e "/^set MODULE_PATH/s:modules:/usr/$(get_libdir)/eiwic:" \
		-e "/^load MODULE/s:$:.so:" \
		sample.conf || die

	eautoreconf
}

src_configure() {
	export ac_cv_lib_raptor_raptor_init=no #409417

	econf \
		$(use_enable debug vv-debug) \
		$(use_enable ipv6)
}

src_install() {
	default
	use doc && dohtml doc/*
}

pkg_postinst() {
	elog "You need a configuration file to run eiwic. A sample configuration"
	elog "was installed to /usr/share/doc/${PF}"
}
