# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/icewm/icewm-1.3.8.ebuild,v 1.8 2015/07/16 06:33:57 polynomial-c Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1

DESCRIPTION="Ice Window Manager with Themes"
HOMEPAGE="http://www.icewm.org/"
LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/${PN}/${P/_}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 sparc x86"
IUSE="bidi debug gnome minimal nls truetype uclibc xinerama"
REQUIRED_USE="gnome? ( ${PYTHON_REQUIRED_USE} )"

# Tests broken in all versions, patches welcome, bug #323907, #389533
RESTRICT="test"

#fix for icewm preversion package names
S=${WORKDIR}/${P/_}

RDEPEND="
	x11-libs/gdk-pixbuf:2[X]
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXft
	x11-libs/libSM
	x11-libs/libICE
	xinerama? ( x11-libs/libXinerama )
	bidi? ( dev-libs/fribidi )
	gnome? (
		${PYTHON_DEPS}
		dev-python/pyxdg
		gnome-base/gnome-desktop:2
		gnome-base/gnome-menus
		gnome-base/libgnomeui )
	nls? ( sys-devel/gettext )
	truetype? ( >=media-libs/freetype-2.0.9 )
	media-libs/giflib
"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	xinerama? ( x11-proto/xineramaproto )
	>=sys-apps/sed-4
"

pkg_setup() {
	if use truetype && use minimal; then
		ewarn "You have both 'truetype' and 'minimal' use flags enabled."
		ewarn "If you really want a minimal install, you will have to turn off"
		ewarn "the truetype flag for this package."
	fi
}

src_prepare() {
	# Fedora patches
	epatch "${FILESDIR}"/${PN}-1.3.8-menu.patch
	epatch "${FILESDIR}"/${PN}-toolbar.patch
	epatch "${FILESDIR}"/${PN}-keys.patch
	epatch "${FILESDIR}"/${PN}-fribidi.patch
	epatch "${FILESDIR}"/${PN}-1.3.7-dso.patch
	epatch "${FILESDIR}"/${PN}-defaults.patch
	epatch "${FILESDIR}"/${PN}-1.3.7-menuiconsize.patch
	epatch "${FILESDIR}"/${PN}-1.3.8-deprecated.patch

	epatch "${FILESDIR}"/${PN}-1.3.7-gcc44.patch

	# Get thermal info from proper locations, bug #452730
	epatch "${FILESDIR}"/${PN}-1.3.7-thermal.patch

	# Debian patch fixing multiple build issues, like bug #470148
	epatch "${FILESDIR}"/${PN}-1.3.8-build-fixes.patch

	# Fix bug #486710
	use uclibc && epatch "${FILESDIR}/${P}-uclibc.patch"

	eautoreconf
}

src_configure() {
	if use truetype
	then
		myconf="${myconf} --enable-gradients --enable-shape --enable-shaped-decorations"
	else
		myconf="${myconf} --disable-xfreetype --enable-corefonts
			$(use_enable minimal lite)"
	fi

	myconf="${myconf}
		--with-libdir=/usr/share/icewm
		--with-cfgdir=/etc/icewm
		--with-docdir=/usr/share/doc/${PF}/html
		$(use_enable bidi fribidi)
		$(use_enable debug)
		$(use_enable gnome menus-gnome2)
		$(use_enable nls i18n)
		$(use_enable nls)
		$(use_enable x86 x86-asm)
		$(use_enable xinerama)
		--without-esd-config"

	CXXFLAGS="${CXXFLAGS}" econf ${myconf}

	sed -i "s:/icewm-\$(VERSION)::" src/Makefile || die "patch failed"
	sed -i "s:ungif:gif:" src/Makefile || die "libungif fix failed"
}

src_install(){
	default

	if use gnome; then
		dobin "${FILESDIR}"/icewm-xdg-menu
		exeinto /usr/share/icewm/
		newexe "${FILESDIR}"/icewm-startup startup
	fi

	dodoc AUTHORS BUGS CHANGES PLATFORMS README* TODO VERSION
	dohtml -a html,sgml doc/*

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/icewm"

	insinto /usr/share/xsessions
	doins "${FILESDIR}/IceWM.desktop"
}
