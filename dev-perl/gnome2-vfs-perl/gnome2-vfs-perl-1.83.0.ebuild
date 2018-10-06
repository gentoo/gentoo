# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=Gnome2-VFS
DIST_AUTHOR=XAOC
DIST_VERSION=1.083
inherit perl-module

DESCRIPTION="Perl interface to the 2.x series of the Gnome Virtual File System libraries"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=gnome-base/gnome-vfs-2
	>=dev-perl/glib-perl-1.120"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.200.0
	>=dev-perl/ExtUtils-PkgConfig-1.03
	virtual/pkgconfig"
