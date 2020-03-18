# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DPATES
inherit perl-module

DESCRIPTION="Fuse module for perl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="sys-fs/fuse"
RDEPEND="
	sys-fs/fuse:=
	dev-perl/Filesys-Statvfs
	dev-perl/Lchown
	dev-perl/Unix-Mknod
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( ${RDEPEND} )
"
