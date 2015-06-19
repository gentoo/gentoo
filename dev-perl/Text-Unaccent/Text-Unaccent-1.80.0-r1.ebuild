# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Unaccent/Text-Unaccent-1.80.0-r1.ebuild,v 1.1 2014/08/22 20:29:23 axs Exp $

EAPI=5

MODULE_AUTHOR=LDACHARY
MODULE_VERSION=1.08
inherit perl-module

DESCRIPTION="Removes accents from a string"

LICENSE="|| ( GPL-2 GPL-3 )" #GPL-2+
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
PATCHES=( "${FILESDIR}"/text-unaccent_size_t.diff )
