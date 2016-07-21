# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ROSCH
MODULE_VERSION=1.00
inherit perl-module

DESCRIPTION="Interpret and act on wait() status values"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ~sparc x86"
IUSE=""

RDEPEND="dev-perl/IPC-Signal"
DEPEND="${RDEPEND}"

SRC_TEST="do"
