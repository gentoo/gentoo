# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SERGEY
MODULE_VERSION=0.7
inherit perl-module

DESCRIPTION="Perl extension for Sound Mixer control"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""

# Dont' enable tests unless your working without a sandbox - expects to write to /dev/mixer
#SRC_TEST="do"
