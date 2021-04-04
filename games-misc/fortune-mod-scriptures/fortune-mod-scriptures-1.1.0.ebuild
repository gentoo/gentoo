# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fortune modules from the King James Bible scriptures"
HOMEPAGE="https://scriptures.nephi.org/"
SRC_URI="mirror://sourceforge/mormon/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="games-misc/fortune-mod"

src_install() {
	dodoc README ChangeLog
	insinto /usr/share/fortune
	doins mods/*
}
