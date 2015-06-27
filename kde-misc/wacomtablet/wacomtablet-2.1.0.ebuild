# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/wacomtablet/wacomtablet-2.1.0.ebuild,v 1.2 2015/06/27 09:47:59 ago Exp $

EAPI=5

KDE_LINGUAS="ar bg bs ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hu ja kk km ko lt mai mr nb nds nl pa pl
pt pt_BR ro ru sk sl sv tr ug uk zh_CN zh_TW"
KDE_DOC_DIRS="doc/user"
KDE_HANDBOOK="optional"
VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="KControl module for Wacom tablets"
HOMEPAGE="http://kde-apps.org/content/show.php?action=content&content=114856"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/114856-${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=x11-drivers/xf86-input-wacom-0.20.0
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	x11-proto/xproto
"
