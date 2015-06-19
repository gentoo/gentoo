# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/webkit-sharp/webkit-sharp-0.3-r1.ebuild,v 1.6 2014/10/31 08:45:41 pacho Exp $

EAPI="4"

inherit mono multilib eutils

DESCRIPTION="WebKit-gtk bindings for Mono"
HOMEPAGE="http://www.mono-project.com/"
SRC_URI="http://mono.ximian.com/monobuild/preview/sources/webkit-sharp/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=dev-lang/mono-2
	>=net-libs/webkit-gtk-1.4:2
	dev-dotnet/gtk-sharp:2"

RDEPEND="${DEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch "${FILESDIR}/${P}-webkit14.patch"
}

src_install() {
	default
	mono_multilib_comply
}
