# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils versionator

DESCRIPTION="Common files used by matchbox-panel and matchbox-desktop packages"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="pda"

RDEPEND=">=x11-libs/libmatchbox-1.1"
DEPEND="${RDEPEND}"

src_compile() {
	econf $(use_enable pda pda-folders)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Insert our Xsession
	echo -e "#!/bin/sh\n\nmatchbox-session" > "${T}"/matchbox
	exeinto /etc/X11/Sessions
	doexe "${T}"/matchbox

	# Insert GDM/KDM xsession file
	wm=matchbox make_session_desktop MatchBox matchbox-session

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/no-utilities-category.patch
	epatch "${FILESDIR}"/add-media-category.patch
}
