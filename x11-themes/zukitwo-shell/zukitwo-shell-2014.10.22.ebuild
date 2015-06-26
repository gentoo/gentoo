# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/zukitwo-shell/zukitwo-shell-2014.10.22.ebuild,v 1.3 2015/06/26 09:24:40 ago Exp $

EAPI=5

DESCRIPTION="Zukitwo theme for GNOME Shell"
HOMEPAGE="http://gnome-look.org/content/show.php/Zukitwo?content=140562"
# Upstream download URI updates file contents without changing the filename
MY_PN="zukitwo"
MY_P="${MY_PN}-${PV}"
SRC_URI="http://www.hartwork.org/public/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=gnome-base/gnome-shell-3.14
	media-fonts/droid
	!<=x11-themes/zukitwo-2011.12.29"
# ${PN} was part of zukitwo before 2011.12.29-r1
DEPEND=""

# INSTALL file contains useful information for the end user
DOCS=( INSTALL README )

S="${WORKDIR}"

src_install() {
	insinto /usr/share/themes
	doins -r ZukiShell
	default
}
