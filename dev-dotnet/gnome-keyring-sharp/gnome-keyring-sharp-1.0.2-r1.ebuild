# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gnome-keyring-sharp/gnome-keyring-sharp-1.0.2-r1.ebuild,v 1.4 2013/12/21 16:27:05 ago Exp $

EAPI=5
inherit autotools eutils mono-env

DESCRIPTION="C# implementation of gnome-keyring"
HOMEPAGE="http://www.mono-project.com/ https://github.com/mono/gnome-keyring-sharp"
SRC_URI="http://www.go-mono.com/archive/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=dev-lang/mono-2.0
	>=gnome-base/libgnome-keyring-2.30.0
	dev-dotnet/glib-sharp
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Disable building samples.
	sed -i -e 's:sample::' "${S}"/Makefile.in || die "sed failed"

	# Apply Fedora patches
	epatch "${FILESDIR}/${PN}-1.0.2-monodoc-dir.patch"
	eautoreconf
}

src_compile() {
	# This dies without telling in docs with anything not -j1
	# CSC=gmcs needed for http://bugs.gentoo.org/show_bug.cgi?id=250069
	emake -j1 CSC=gmcs
}

src_install() {
	default
	prune_libtool_files --modules
}
