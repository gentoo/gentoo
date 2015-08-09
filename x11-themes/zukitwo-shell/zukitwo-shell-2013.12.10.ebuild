# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Zukitwo theme for GNOME Shell"
HOMEPAGE="http://gnome-look.org/content/show.php/Zukitwo?content=140562"
# Upstream download URI updates file contents without changing the filename
MY_PN="zukitwo"
MY_P="${MY_PN}-${PV}"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=gnome-base/gnome-shell-3.4
	media-fonts/ubuntu-font-family
	!<=x11-themes/zukitwo-2011.12.29"
# ${PN} was part of zukitwo before 2011.12.29-r1
DEPEND="app-arch/xz-utils"

# INSTALL file contains useful information for the end user
DOCS=( INSTALL README )

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/share/themes
	doins -r Zukitwo-Shell
	default
}
