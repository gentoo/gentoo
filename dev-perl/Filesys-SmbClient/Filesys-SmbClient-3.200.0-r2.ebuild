# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ALIAN
DIST_VERSION=3.2
inherit perl-module autotools

DESCRIPTION="Provide Perl API for libsmbclient.so"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=net-fs/samba-4.2[client]"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
"

# tests are not designed to work on a non-developer system.
RESTRICT=test

PATCHES=(
	"${FILESDIR}/${P}-pkg_config.patch"
	"${FILESDIR}/${P}-close_fn.patch"
)

src_prepare() {
	perl-module_src_prepare
	eautoreconf
}
