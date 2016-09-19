# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="LXAppearance plugin for configuring OpenBox"
HOMEPAGE="http://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~x86"
IUSE=""

RDEPEND="lxde-base/lxappearance
	x11-wm/openbox"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool"

src_install() {
	default
	prune_libtool_files
}
