# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BTROTT
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Create bubble-babble fingerprints"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""
PATCHES=( "${FILESDIR}/0.02-dot-in-inc.patch" ) # https://github.com/btrott/Digest-BubbleBabble/pull/1
SRC_TEST="do parallel"
