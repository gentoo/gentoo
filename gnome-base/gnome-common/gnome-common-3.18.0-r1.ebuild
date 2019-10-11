# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Common files for development of Gnome packages"
HOMEPAGE="https://git.gnome.org/browse/gnome-common"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND=""
DEPEND=""

src_configure() {
	# Force people to rely on sys-devel/autoconf-archive, bug #594084
	gnome2_src_configure --with-autoconf-archive
}
