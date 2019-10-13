# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool to find and launch installed applications for the Xfce desktop"
HOMEPAGE="https://docs.xfce.org/xfce/xfce4-appfinder/start"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/glib-2.42
	>=x11-libs/gtk+-3.20:3
	>=xfce-base/garcon-0.3:=
	>=xfce-base/libxfce4util-4.11:=
	>=xfce-base/libxfce4ui-4.11:=[gtk3(+)]
	>=xfce-base/xfconf-4.10:=
	!xfce-base/xfce-utils"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
