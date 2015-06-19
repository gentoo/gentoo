# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/mono-zeroconf/mono-zeroconf-0.9.0.ebuild,v 1.7 2014/08/10 20:03:22 slyfox Exp $

EAPI=2

inherit base mono

DESCRIPTION="a cross platform Zero Configuration Networking library for Mono and .NET"
HOMEPAGE="http://www.mono-project.com/Mono.Zeroconf"
SRC_URI="http://banshee-project.org/files/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND=">=dev-lang/mono-2.0
	>=net-dns/avahi-0.6[mono]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable doc docs) --enable-avahi
}

src_compile() {
	emake -j1 || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README || die "docs failed"
	mono_multilib_comply
}
