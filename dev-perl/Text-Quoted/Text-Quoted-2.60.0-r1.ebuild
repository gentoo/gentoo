# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Quoted/Text-Quoted-2.60.0-r1.ebuild,v 1.1 2014/08/24 01:38:39 axs Exp $

EAPI=5

MODULE_AUTHOR=RUZ
MODULE_VERSION=2.06
inherit perl-module

DESCRIPTION="Extract the structure of a quoted mail message"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-perl/text-autoformat"
DEPEND="${RDEPEND}"

SRC_TEST="do"
