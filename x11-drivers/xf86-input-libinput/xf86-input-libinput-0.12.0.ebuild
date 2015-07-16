# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-libinput/xf86-input-libinput-0.12.0.ebuild,v 1.1 2015/07/16 15:03:19 mrueg Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libinput-0.19.0:0="
DEPEND="${RDEPEND}"

DOCS=( "README.md" "conf/99-libinput.conf" )
