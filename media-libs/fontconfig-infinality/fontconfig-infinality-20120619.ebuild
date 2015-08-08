# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Configuration to be used in conjunction with the freetype-infinality subpixel hinting"
HOMEPAGE="http://www.infinality.net/blog/infinality-freetype-patches/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz
	nyx? ( http://dev.gentoo.org/~yngwin/distfiles/fontconfig-nyx-1.tar.xz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+nyx"

DEPEND=""
RDEPEND="app-eselect/eselect-fontconfig
	app-eselect/eselect-infinality
	app-eselect/eselect-lcdfilter
	>=x11-libs/libXft-2.3.0
	nyx? ( media-fonts/croscorefonts )"
PDEPEND="media-libs/freetype:2[infinality]"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodoc infinality/{CHANGELOG,CHANGELOG.pre_git,README}

	insinto /etc/fonts/conf.avail
	doins conf.avail/52-infinality.conf

	insinto /etc/fonts/infinality
	doins -r infinality/{conf.src,styles.conf.avail,infinality.conf}

	insinto /etc/X11/
	doins "${FILESDIR}"/Xresources

	if use nyx ; then
		insinto /etc/fonts/infinality/styles.conf.avail
		doins -r "${WORKDIR}"/nyx
	fi
}

pkg_postinst() {
	elog "Use eselect fontconfig enable 52-infinality.conf"
	elog "to enable the configuration"
	elog "Then use eselect infinality to set your fontconfig style"
	elog "and eselect lcdfilter to set freetype variables"
}
