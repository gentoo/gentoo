# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TURNSTEP
MODULE_VERSION=2.06
inherit perl-module

DESCRIPTION="High speed arbitrary size integer math"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha amd64 hppa ~mips ppc x86"
IUSE=""

RDEPEND="dev-libs/gmp"
DEPEND="${RDEPEND}"

SRC_TEST=do
