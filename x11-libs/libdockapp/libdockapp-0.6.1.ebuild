# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

IUSE=""

DESCRIPTION="Window Maker Dock Applet Library"
SRC_URI="http://solfertje.student.utwente.nl/~dalroi/libdockapp/files/${P}.tar.bz2"
HOMEPAGE="http://solfertje.student.utwente.nl/~dalroi/libdockapp/"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

S=${WORKDIR}/${P/lib/}
FONTDIR="/usr/share/fonts/${PN}-fonts"

src_unpack()
{
	unpack ${A}
	cd "${S}"

	# sanitize fonts installation path
	epatch "${FILESDIR}/install-paths.patch-${PV}"

	# add legacy support for older dockapps
	epatch "${FILESDIR}/legacy.patch-${PV}"

	eautoreconf
}

src_install()
{
	make                                                    \
		DESTDIR="${D}"                                      \
		SHAREDIR="${D}/usr/share/doc/${PF}/examples/"       \
		install || die "make install failed"

	dodoc README ChangeLog NEWS AUTHORS
}

pkg_postinst()
{
	einfo
	einfo "You need to add following line into 'Section \"Files\"' in"
	einfo "/etc/X11/xorg.conf (or /etc/X11/XF86Config if you are still using XFree86)"
	einfo "and reboot X Window System, to use these fonts."
	einfo
	einfo "\t FontPath \"${FONTDIR}\""
	einfo
	einfo "You also need to add the following line to /etc/fonts/local.conf"
	einfo
	einfo "\t <dir>${FONTDIR}</dir>"
	einfo
}

pkg_postrm()
{
	einfo
	einfo "You need to remove following line from 'Section \"Files\"' in"
	einfo "/etc/X11/xorg.conf (or /etc/X11/XF86Config if you are still using XFree86)"
	einfo "to unmerge this package completely."
	einfo
	einfo "\t FontPath \"${FONTDIR}\""
	einfo
	einfo "You also need to remove the following line from /etc/fonts/local.conf"
	einfo
	einfo "\t <dir>${FONTDIR}</dir>"
	einfo
}
