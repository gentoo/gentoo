# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Connection forwarder that converts Unix sockets into TCP sockets"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ~s390 x86"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

DOCS=( ChangeLog README )

src_prepare() {
	default

	eautoreconf #870457
}
