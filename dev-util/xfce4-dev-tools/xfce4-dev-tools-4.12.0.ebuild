# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xfconf

DESCRIPTION="A set of scripts and m4/autoconf macros that ease build system maintenance"
HOMEPAGE="https://www.xfce.org/ http://users.xfce.org/~benny/projects/xfce4-dev-tools/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.30"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS=( AUTHORS ChangeLog HACKING NEWS README )
}
