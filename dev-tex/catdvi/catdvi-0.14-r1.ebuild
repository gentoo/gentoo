# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils autotools toolchain-funcs flag-o-matic

DESCRIPTION="DVI to plain text translator"
HOMEPAGE="http://catdvi.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/tex-base
	dev-libs/kpathsea"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-kpathsea.patch"
	eautoconf
	has_version '>=dev-libs/kpathsea-6.2.1' && append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"
}

src_compile() {
	# Do not use plain emake here, because make tests
	# may cache fonts and generate sandbox violations.
	emake catdvi CC="$(tc-getCC)"
}

src_install() {
	dobin catdvi
	doman catdvi.1
	dodoc AUTHORS ChangeLog NEWS README TODO
}
