# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-attachwarner/claws-mail-attachwarner-1.0.ebuild,v 1.6 2014/08/10 21:17:05 slyfox Exp $

MY_P="${P#claws-mail-}"

DESCRIPTION="Warn about missing attachment, if it's mentioned in message body"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"
RDEPEND="~mail-client/claws-mail-3.9.0
		nls? ( >=sys-devel/gettext-0.12.1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf $(use_enable nls) || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
