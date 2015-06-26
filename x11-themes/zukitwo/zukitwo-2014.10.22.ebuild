# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/zukitwo/zukitwo-2014.10.22.ebuild,v 1.3 2015/06/26 09:24:38 ago Exp $

EAPI="5"

DESCRIPTION="Theme for GNOME 2 and 3"
HOMEPAGE="http://gnome-look.org/content/show.php/Zukitwo?content=140562"
# Upstream download URI updates file contents without changing the filename
SRC_URI="http://www.hartwork.org/public/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gnome-shell"

RDEPEND=">=x11-libs/gtk+-2.10:2
	>=x11-libs/gtk+-3.14:3
	>=x11-themes/gnome-themes-standard-3.6
	>=x11-themes/gtk-engines-murrine-0.98.1.1
	gnome-shell? ( x11-themes/zukitwo-shell )"
DEPEND="app-arch/xz-utils"

# INSTALL file contains useful information for the end user
DOCS=( INSTALL README )

S="${WORKDIR}"

src_install() {
	insinto /usr/share/themes
	doins -r Zukitwo
	insinto /usr/share/themes/Zukitwo
	doins panelbg.png
	default
}
