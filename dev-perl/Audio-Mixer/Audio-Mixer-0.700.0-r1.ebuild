# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-Mixer/Audio-Mixer-0.700.0-r1.ebuild,v 1.1 2014/08/22 18:45:52 axs Exp $

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
