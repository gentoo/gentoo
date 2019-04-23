# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Off-The-Record messaging (OTR) for irssi"
HOMEPAGE="https://github.com/cryptodotis/irssi-otr"
SRC_URI="https://github.com/cryptodotis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa sparc x86"

RDEPEND="
	!=net-irc/irssi-1.2*
	dev-libs/glib:2
	>=dev-libs/libgcrypt-1.7.3
	>=net-libs/libotr-4.1.0
	>=net-irc/irssi-1.0.0[perl]"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

DOCS=( README.md )

PATCHES=( "${FILESDIR}/${P}-cflags.patch" )

src_prepare() {
	default
	eautoreconf
	sed -i -e "s|/usr/lib/irssi/modules|/usr/$(get_libdir)/irssi/modules|" configure.ac || die
}
