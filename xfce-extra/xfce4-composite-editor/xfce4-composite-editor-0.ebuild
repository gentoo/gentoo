# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-composite-editor/xfce4-composite-editor-0.ebuild,v 1.2 2015/07/01 08:12:30 zlogene Exp $

EAPI=5
inherit xfconf

MY_PN=Xfce4-Composite-Editor

DESCRIPTION="An graphical interface to modify composite settings"
HOMEPAGE="http://keithhedger.hostingsiteforfree.com/pages/apps.html#xfcecomp"
SRC_URI="http://keithhedger.hostingsiteforfree.com/zips/${MY_PN}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="app-shells/bash
	>=x11-misc/gtkdialog-0.8"
DEPEND="${RDEPEND}"

S=${WORKDIR}

pkg_setup() {
	PATCHES=( "${FILESDIR}"/${P}-validate.patch )
}

src_configure() { :; }
src_compile() { :; }

src_install() {
	dobin xfce4-composite-editor
	domenu xfcecomped.desktop
	dodoc README
}
