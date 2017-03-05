# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="HARDAKER"
MODULE_VERSION=0.93
inherit perl-module

DESCRIPTION="Auto-GUI extending Getopt::Long"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-File-Temp
	virtual/perl-Getopt-Long"
