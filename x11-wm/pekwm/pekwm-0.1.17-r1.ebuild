# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A lightweight window manager initially based on aewm++"
HOMEPAGE="http://pekwm.org/"
SRC_URI="
	http://pekwm.org/projects/pekwm/files/${P}.tar.bz2
	themes? ( mirror://gentoo/${PN}-themes.tar.bz2 )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=" amd64 ~mips ppc x86"
IUSE="contrib debug themes truetype xinerama"

RDEPEND="
	media-libs/libpng:0=
	virtual/jpeg:0
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	truetype? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	if use themes; then
		rm "${WORKDIR}"/themes/Ace/.theme.swp || die
	fi
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		--enable-image-jpeg \
		--enable-image-png \
		--enable-image-xpm \
		--enable-shape \
		--enable-xrandr
}

src_install() {
	default

	# Install contributor scripts into doc folder
	if use contrib ; then
		docinto /usr/share/doc/${PF}/contrib
		dodoc contrib/lobo/{check.png,pekwm_autoprop.pl,pekwm_menu_config.pl} \
			contrib/lobo/{pekwm_menu_config.pl.vars,README,uncheck.png}
	fi

	if use themes; then
		insinto /usr/share/${PN}/themes
		doins -r "${WORKDIR}"/themes/*
	fi

	# Insert an Xsession
	echo -e "#!/bin/sh\n\n/usr/bin/${PN}" > "${T}"/${PN} || die
	exeinto /etc/X11/Sessions
	doexe "${T}"/${PN}

	# Insert a GDM/KDM xsession file
	make_session_desktop ${PN} ${PN}
}

pkg_postinst() {
	if use contrib ; then
		elog " User contributed scripts have been installed into:"
		elog " /usr/share/doc/${PF}/contrib"
	fi
}
