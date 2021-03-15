# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

PATCHES=( "${FILESDIR}"/${P}-{no-strip,install}.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-gtk2
}

src_install() {
	default

	rm -r "${D}"/usr/share/doc || die
	use doc && local HTML_DOCS=( doc/. )
	einstalldocs

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins samples/*
	fi
}
