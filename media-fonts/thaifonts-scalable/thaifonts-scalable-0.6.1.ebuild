# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/thaifonts-scalable/thaifonts-scalable-0.6.1.ebuild,v 1.3 2015/04/28 10:06:05 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="A collection of Free fonts for Thai"
HOMEPAGE="http://linux.thai.net/projects/thaifonts-scalable"
SRC_URI="ftp://linux.thai.net/pub/thailinux/software/thai-ttf/ttf-tlwg-${PV}.tar.xz"

LICENSE="|| ( GPL-2-with-font-exception GPL-3-with-font-exception )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

S="${WORKDIR}/ttf-tlwg-${PV}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
FONT_CONF=(
	"${FONT_S}/etc/fonts/conf.avail/64-01-tlwg-kinnari.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-02-tlwg-norasi.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-11-tlwg-waree.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-12-tlwg-loma.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-13-tlwg-garuda.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-14-tlwg-umpush.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-15-laksaman.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-21-tlwg-typo.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-22-tlwg-typist.conf"
	"${FONT_S}/etc/fonts/conf.avail/64-23-tlwg-mono.conf"
	"${FONT_S}/etc/fonts/conf.avail/89-tlwg-garuda-synthetic.conf"
	"${FONT_S}/etc/fonts/conf.avail/89-tlwg-kinnari-synthetic.conf"
	"${FONT_S}/etc/fonts/conf.avail/89-tlwg-laksaman-synthetic.conf"
	"${FONT_S}/etc/fonts/conf.avail/89-tlwg-loma-synthetic.conf"
	"${FONT_S}/etc/fonts/conf.avail/89-tlwg-umpush-synthetic.conf"
	"${FONT_S}/etc/fonts/conf.avail/89-tlwg-waree-synthetic.conf" )

pkg_postinst() {
	font_pkg_postinst
	echo
	elog "  64-*.conf enable basic support"
	elog "  89-*-synthetic.conf emulate the Thai font of Windows"
	echo
}
