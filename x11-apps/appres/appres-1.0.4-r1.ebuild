# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="list X application resource database"
HOMEPAGE="https://www.x.org/wiki/ https://cgit.freedesktop.org/"
SRC_URI="mirror://xorg/app/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE=""

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-misc/util-macros
"
