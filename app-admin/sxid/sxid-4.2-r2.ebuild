# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="suid, sgid file and directory checking"
HOMEPAGE="http://freshmeat.net/projects/sxid"
SRC_URI="http://linukz.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="virtual/mailx"

DOCS=( docs/sxid.{conf,cron}.example )

src_prepare() {
	default
	# this is an admin application and really requires root to run correctly
	# we need to move the binary to the sbin directory
	sed -i s/bindir/sbindir/g source/Makefile.in || die
	eautoreconf
}

pkg_postinst() {
	elog
	elog "You will need to configure sxid.conf for your system using the manpage and example"
	elog
}
