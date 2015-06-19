# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sisusb/xf86-video-sisusb-0.9.5.ebuild,v 1.1 2012/07/05 16:00:58 chithanh Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="SiS USB video driver"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.6"
DEPEND="${RDEPEND}"
