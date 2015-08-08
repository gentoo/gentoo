# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="a dockapp and gkrellm2 plugin that fetches the DSL usage information for Australian ISP Internode"
HOMEPAGE="http://www.earthmagic.org/?software"
SRC_URI="http://www.earthmagic.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="gtk"

RDEPEND="dev-libs/openssl
	gtk? (
		x11-libs/gtk+:2
		app-admin/gkrellm:2
	)
	!gtk? ( x11-wm/windowmaker )
	>=x11-libs/libX11-1
	>=x11-libs/libXext-1
	>=x11-libs/libXpm-3.5.4.2"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
	>=x11-proto/xextproto-7.0.2"

src_prepare() {
	#Honour Gentoo LDFLAGS, bug #334003
	sed -ie "s/\$(CXXFLAGS) -o/\$(CXXFLAGS) \$(LDFLAGS) -o/" src/Makefile
	sed -ie "s/-shared -o/-shared \$(LDFLAGS) -o/" src-gk2/Makefile
}

src_compile() {
	emake build || die
	if use gtk; then
		emake build-gk2 || die
	fi
}

src_install() {
	if use gtk; then
		exeinto /usr/lib/gkrellm2/plugins
		doexe src-gk2/wmium-gk2.so
	fi

	dobin src/wmium

	dodoc BUGS README dot.wmiumrc.sample CHANGES README-GK2

	doman src/wmium.1

	einfo
	einfo "To configure look at the /usr/share/doc/${PF}/dot.wmiumrc.sample"
	einfo "(if using /usr/bin/wmium with WINDOWMAKER ONLY)"
	einfo
	einfo "or use the preferences within gkrellm2"
}
