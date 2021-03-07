# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="l10n_cs l10n_de lirc nls udev xinerama"

DEPEND="
	media-libs/xine-lib[gtk]
	x11-libs/gtk+:2
	dev-lang/spidermonkey:0
	dev-libs/glib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libxcb
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	udev? ( dev-libs/libgudev:= )
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	# need to disable calling of xine-list when running without
	# userpriv, otherwise we get sandbox violations (bug #233847)
	if [[ ${EUID} == 0 ]]; then
		sed -i -e 's:^XINE_LIST=.*$:XINE_LIST=:' configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	econf \
		--enable-watchdog \
		--with-xcb \
		--without-browser-plugin \
		--without-dbus \
		--without-hal \
		$(use_enable nls) \
		$(use_enable lirc) \
		$(use_with udev gudev) \
		$(use_with xinerama)
}

src_install() {
	emake DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		docsdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	dodoc AUTHORS BUGS ChangeLog README{,_l10n} TODO

	use l10n_cs && dodoc README.cs
	use l10n_de && dodoc README.de
}
