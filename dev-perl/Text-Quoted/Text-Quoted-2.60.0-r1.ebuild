# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RUZ
MODULE_VERSION=2.06
inherit perl-module

DESCRIPTION="Extract the structure of a quoted mail message"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-perl/Text-Autoformat"
DEPEND="${RDEPEND}"

SRC_TEST="do"
