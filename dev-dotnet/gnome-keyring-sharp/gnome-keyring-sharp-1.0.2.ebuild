# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnome-keyring-sharp/gnome-keyring-sharp-1.0.2.ebuild,v 1.7 2014/01/19 20:58:53 moult Exp $

EAPI="2"

inherit mono

DESCRIPTION="C# implementation of gnome-keyring"
HOMEPAGE="http://www.mono-project.com/ https://github.com/mono/gnome-keyring-sharp"
SRC_URI="http://www.go-mono.com/archive/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND=">=dev-lang/mono-2.0
	>=gnome-base/libgnome-keyring-2.30.0
	dev-dotnet/glib-sharp"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Disable building samples.
	sed -i -e 's:sample::' "${S}"/Makefile.in || die "sed failed"
}

src_configure() {
	econf $(use_enable doc monodoc) || die "econf failed"
}

src_compile() {
	# This dies without telling in docs with anything not -j1
	# CSC=gmcs needed for http://bugs.gentoo.org/show_bug.cgi?id=250069
	emake -j1 CSC=gmcs || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README || die
	mono_multilib_comply
	find "${D}" -name '*.la' -exec rm -rf '{}' '+' || die "la removal failed"
}
