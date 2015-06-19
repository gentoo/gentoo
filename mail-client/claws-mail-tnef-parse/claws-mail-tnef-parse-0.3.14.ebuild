# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-tnef-parse/claws-mail-tnef-parse-0.3.14.ebuild,v 1.5 2013/05/08 04:06:17 fauli Exp $

EAPI=4

inherit multilib

MY_P="${P#claws-mail-}"
MY_P="${MY_P/-/_}"

DESCRIPTION="Plugin for Claws to support application/ms-tnef attachments"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RDEPEND="~mail-client/claws-mail-3.9.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
