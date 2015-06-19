# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-Wav/Audio-Wav-0.130.0-r1.ebuild,v 1.1 2014/08/24 01:26:55 axs Exp $

EAPI=5

MODULE_AUTHOR=BRIANSKI
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Modules for reading & writing Microsoft WAV files"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

RDEPEND="dev-perl/Inline"
DEPEND="${RDEPEND}"

SRC_TEST="do"
