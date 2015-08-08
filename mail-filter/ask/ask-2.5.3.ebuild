# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

DESCRIPTION="Active Spam Killer: A program to filter spam"
HOMEPAGE="http://www.paganini.net/ask/index.html"
SRC_URI="mirror://sourceforge/a-s-k/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="procmail"
RDEPEND="dev-lang/python
		virtual/mta
		procmail? ( >=mail-filter/procmail-3.22 )"

src_install() {
	dobin askfilter asksetup askversion.py utils/asksenders

	insinto /usr/$(get_libdir)/ask
	doins askconfig.py asklock.py asklog.py askmail.py askmain.py \
		 askmessage.py askremote.py

	insinto /usr/share/ask/templates
	doins templates/*

	insinto /usr/share/ask/utils
	doins utils/*

	doman docs/*.1

	dodoc ChangeLog docs/ask_doc*
}

pkg_postinst() {
	elog "You MUST run the asksetup file to configure ASK!"
	elog "WARNING: if you upgrade from ask-2.4.1, you must replace ask.py with askfilter"
	elog "         in your procmail/maildrop recipe!"
}
