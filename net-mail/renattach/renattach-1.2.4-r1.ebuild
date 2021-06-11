# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Filter that renames/deletes dangerous email attachments"
HOMEPAGE="http://www.pc-tools.net/unix/renattach/"
SRC_URI="http://www.pc-tools.net/files/unix/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

src_install() {
	emake DESTDIR="${D}" install

	mv "${ED}"/etc/renattach.conf.ex "${ED}"/etc/renattach.conf || die

	dodoc AUTHORS ChangeLog README NEWS
}
