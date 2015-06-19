# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-ShareDir-Install/File-ShareDir-Install-0.90.0.ebuild,v 1.1 2014/10/24 19:02:34 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=GWYN
MODULE_VERSION=0.09

inherit perl-module

DESCRIPTION="Install shared files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.110.0
	virtual/perl-File-Spec
	virtual/perl-IO
"
DEPEND="${RDEPEND}"

SRC_TEST="do parallel"
