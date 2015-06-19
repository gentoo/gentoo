# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mlmmj/mlmmj-1.2.19.0.ebuild,v 1.1 2015/06/18 00:08:33 robbat2 Exp $

EAPI=4

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Mailing list managing made joyful"
HOMEPAGE="http://mlmmj.org/"
SRC_URI="http://mlmmj.org/releases/${MY_P}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
DEPEND="virtual/mta"
S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS ChangeLog FAQ README* TODO TUNABLES UPGRADE"

src_configure() {
	econf --enable-receive-strip
}

src_install() {
	default

	insinto /usr/share/mlmmj/texts
	doins listtexts/*

	insinto /usr/share/mlmmj
	doins -r contrib/web/*
}

pkg_postinst() {
	elog "mlmmj comes with serveral webinterfaces:"
	elog "- One for user subscribing/unsubscribing"
	elog "- One for admin tasks"
	elog "both available in a php and perl module."
	elog "For more info have a look in /usr/share/mlmmj"
}
