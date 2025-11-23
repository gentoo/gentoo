# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Drop-in replacement for cdialog using GTK"
HOMEPAGE="http://xdialog.free.fr/"
SRC_URI="http://${PN}.free.fr/Xdialog-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc x86"
IUSE="doc examples nls"

RDEPEND="
	dev-libs/glib:2
	>=x11-libs/gtk+-2.2:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${P/x/X}"

DOCS=( AUTHORS BUGS ChangeLog README )

PATCHES=(
	"${FILESDIR}"/${P}-no-strip.patch
	"${FILESDIR}"/${P}-install.patch
)

src_prepare() {
	default

	sed -i -e 's:configure.in:configure.ac:' configure.in || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-gtk2
}

src_install() {
	default

	rm -r "${ED}"/usr/share/doc || die
	use doc && local HTML_DOCS=( doc/. )
	einstalldocs

	if use examples; then
		docinto examples
		dodoc samples/*
	fi
}
