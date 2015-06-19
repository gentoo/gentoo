# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-python/claws-mail-python-0.11.ebuild,v 1.5 2013/05/08 04:02:52 fauli Exp $

EAPI=4
inherit multilib

MY_P="${PN#claws-mail-}_plugin-${PV}"

DESCRIPTION="Plugin to integrate with Python"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND="~mail-client/claws-mail-3.9.0
	>=dev-lang/python-2.5
	>=dev-python/pygtk-2.10.3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
