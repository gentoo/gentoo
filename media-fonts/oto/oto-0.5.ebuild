# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Open Type Organizer"
HOMEPAGE="https://sourceforge.net/projects/oto/"
SRC_URI="https://downloads.sourceforge.net/oto/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~loong ~ppc ~s390 sparc x86"

src_prepare() {
	default

	eautoreconf #871381
}
