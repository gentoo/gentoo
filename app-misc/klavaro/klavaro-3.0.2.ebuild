# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

MY_P="${PN}-$(delete_version_separator 2)"

DESCRIPTION="Another free touch typing tutor program"
HOMEPAGE="http://klavaro.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+static-libs"

RDEPEND="
	net-misc/curl
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango
"
DEPEND="${RDEPEND}
	dev-util/intltool
	>=sys-devel/gettext-0.18.3
	dev-util/gtk-builder-convert
	"

S="${WORKDIR}"/${MY_P}


