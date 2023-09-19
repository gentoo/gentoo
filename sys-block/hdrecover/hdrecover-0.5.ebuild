# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Attempts to recover a hard disk that has bad blocks on it"
HOMEPAGE="https://hdrecover.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	# we don't want the command to be visible to non-root users.
	econf --bindir=/usr/sbin
}
