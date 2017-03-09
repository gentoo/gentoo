# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	|| ( >=dev-dotnet/gtk-sharp-2.12.21 dev-dotnet/glib-sharp )
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
	# CSC=gmcs needed for https://bugs.gentoo.org/show_bug.cgi?id=250069
	# Changed to CSC=mcs for mono-4 compatibility
	emake -j1 CSC=mcs
}

src_install() {
	default
	prune_libtool_files --modules
}
