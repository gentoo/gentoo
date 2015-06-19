# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sparkleshare/sparkleshare-1.1.0.ebuild,v 1.3 2013/12/08 19:32:33 pacho Exp $

EAPI=5
GCONF_DEBUG="no" # --enable-debug does not do anything

inherit gnome2 mono-env

DESCRIPTION="Git-based collaboration and file sharing tool"
HOMEPAGE="http://www.sparkleshare.org"
SRC_URI="https://bitbucket.org/hbons/sparkleshare/downloads/sparkleshare-linux-${PV}-tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="" # ayatana

COMMON_DEPEND=">=dev-lang/mono-2.8
	>=dev-dotnet/glib-sharp-2.12.7
	>=dev-dotnet/gtk-sharp-2.12.10
	dev-dotnet/notify-sharp
	dev-dotnet/webkit-sharp
"
RDEPEND="${COMMON_DEPEND}
	>=dev-vcs/git-1.7.12
	gnome-base/gvfs
	net-misc/curl[ssl]
	net-misc/openssh
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_configure() {
	DOCS="News.txt legal/Authors.txt README.md"
	gnome2_src_configure --disable-appindicator
	#       $(use_enable ayatana appindicator)
	# requires >=appindicator-sharp-0.0.7
}
