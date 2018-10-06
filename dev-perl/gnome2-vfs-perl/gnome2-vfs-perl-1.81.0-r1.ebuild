# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=Gnome2-VFS
MODULE_AUTHOR=TSCH
MODULE_VERSION=1.081
inherit perl-module

DESCRIPTION="Perl interface to the 2.x series of the Gnome Virtual File System libraries"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=gnome-base/gnome-vfs-2
	>=dev-perl/glib-perl-1.120"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.2
	>=dev-perl/ExtUtils-PkgConfig-1.03
	virtual/pkgconfig"

SRC_TEST=skip
# bug 423473
