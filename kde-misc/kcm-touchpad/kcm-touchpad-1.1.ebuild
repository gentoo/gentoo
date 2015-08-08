# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KCM, daemon and applet for touchpad"
HOMEPAGE="https://projects.kde.org/projects/playground/utils/kcm-touchpad"
if [[ "${PV}" == *9999 ]]; then
	KEYWORDS=""
else
	SRC_URI="http://quickgit.kde.org/?p=kcm-touchpad.git&a=snapshot&t=v${PV} -> ${P}.tar.gz"
	S=${WORKDIR}/${PN}
	KEYWORDS="amd64 x86"
fi
LICENSE="GPL-2+"
SLOT="4"
IUSE="debug"

DEPEND="x11-drivers/xf86-input-synaptics
	x11-libs/libxcb
"
RDEPEND="${DEPEND}"
