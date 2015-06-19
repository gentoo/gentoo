# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/redhat-artwork/redhat-artwork-5.0.8-r4.ebuild,v 1.15 2014/07/01 23:16:57 jer Exp $

EAPI=5
inherit autotools eutils rpm

MY_R=${PR/r/}
DESCRIPTION="RedHat's Bluecurve theme for GTK2, KDE, GDM, Metacity and Nautilus"
HOMEPAGE="http://www.redhat.com"
SRC_URI="mirror://gentoo/${P}-${MY_R}.fc7.src.rpm"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc sparc x86"
IUSE="audacious cursors gdm icons kdm nautilus"

RDEPEND="x11-libs/gtk+:2"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	media-gfx/icon-slicer
	virtual/pkgconfig
"

RESTRICT="test"

src_unpack() {
	rpm_src_unpack
}

src_prepare() {
	epatch "${WORKDIR}"/redhat-artwork-5.0.5-add-dirs-to-bluecurve-theme-index.patch
	epatch "${WORKDIR}"/redhat-artwork-5.0.8-echo.patch

	# dies if LANG has UTF-8
	export LANG=C
	export LC_ALL=C

	rm -f configure
	sed -i \
		-e 's|.*MCOPIDL.*||' \
		-e 's|.*ARTSCCONFIG.*||' \
		acinclude.m4 || die

	sed -i \
		-e 's|AC_PATH_KDE||' \
		-e 's|KDE_CHECK_FINAL||' \
		-e 's|KDE_SET_PREFIX||' \
		-e 's|art/kde/Makefile||' \
		-e 's|art/kde/kwin/Bluecurve/Makefile||' \
		-e 's|art/kde/kwin/Makefile||' \
		-e 's|dnl KDE_USE_QT||' \
		configure.in || die

	sed -i \
		-e 's|kde||' \
		-e 's|qt||' \
		art/Makefile.am || die

	sed -i \
		-e 's| $(datadir)| $(DESTDIR)$(datadir)|' \
		art/cursor/Bluecurve/Makefile.am \
		art/cursor/Bluecurve-inverse/Makefile.am \
		art/cursor/LBluecurve/Makefile.am \
		art/cursor/LBluecurve-inverse/Makefile.am \
		art/icon/Makefile.am \
		art/icon/Bluecurve/sheets/Makefile.am || die

	eautoreconf

	intltoolize --force || die

	sed -i -e 's|GtkStyle|4|' art/qt/Bluecurve/bluecurve.cpp || die
}

src_compile() {
	emake QTDIR="${QTDIR}" styledir="${QTDIR}/plugins/styles"
}

src_install () {
	# dies if LANG has UTF-8
	export LANG=C
	export LC_ALL=C

	emake \
		QTDIR="${QTDIR}" \
		styledir="${QTDIR}/plugins/styles" \
		DESTDIR="${D}" \
		install

	# yank redhat logos (registered trademarks, etc)
	rm -f "${D}/usr/share/gdm/themes/Bluecurve/rh_logo-header.png"
	rm -f "${D}/usr/share/gdm/themes/Bluecurve/screenshot.png"

	cd "${D}/usr/share/gdm/themes/Bluecurve/" || die

	# replace redhat logo with gnome logo from happygnome theme, use .svg if >=gnome-base/gdm-2.14 installed
	if has_version gnome-base/gdm >=2.14; then
		sed -i \
			-e 's|<normal file="rh_logo-header.png"/>|<normal file="/usr/share/gdm/themes/happygnome/gnome-logo.svg"/>|' \
			-e 's|<pos x="3%" y="5%" width="398" height="128" anchor="nw"/>|<pos x="3%" y="3%"/>|' Bluecurve.xml \
			|| die
	else
		sed -i \
			-e 's|<normal file="rh_logo-header.png"/>|<normal file="/usr/share/gdm/themes/happygnome/gnome-logo.png"/>|' \
			-e 's|<pos x="3%" y="5%" width="398" height="128" anchor="nw"/>|<pos x="3%" y="3%"/>|' Bluecurve.xml \
			|| die
	fi

	# Bluecurve GDM screenshot has redhat logo
	# Theme copyright notice left intact... do not modify it
	sed -i -e 's|Screenshot=|#Screenshot=|' GdmGreeterTheme.desktop || die

	X11_IMPLEM="xorg-x11"

	for x in Bluecurve Bluecurve-inverse; do
		dodir /usr/share/cursors/${X11_IMPLEM}/${x}
		mv "${D}"/usr/share/icons/${x}/cursors "${D}"/usr/share/cursors/${X11_IMPLEM}/${x}
		dosym /usr/share/cursors/${X11_IMPLEM}/${x}/cursors /usr/share/icons/${x}/cursors
	done

	# remove audacious skin if unneeded
	if ! use audacious; then
		rm -r "${D}"/usr/share/xmms || die
	else
		mv "${D}"/usr/share/xmms "${D}"/usr/share/audacious || die
	fi

	cd "${S}"
	dodoc AUTHORS NEWS README ChangeLog

	###
	# Some extra features - allows redhat-artwork to be very light:
	###
	if ! use gdm; then rm -r "${D}"/usr/share/gdm || die; fi
	if ! use kdm; then rm -r "${D}"/usr/share/apps/kdm || die; fi
	if ! use cursors; then rm -r "${D}"/usr/share/cursors || die; fi
	if ! use icons; then
		rm -r "${D}"/usr/share/icons || die
		rm -r "${D}"/usr/share/pixmaps/*.png || die
	fi
	if ! use nautilus; then rm -r "${D}"/usr/share/pixmaps/nautilus || die; fi
}
