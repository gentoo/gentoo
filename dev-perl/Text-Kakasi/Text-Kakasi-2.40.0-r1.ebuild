# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Kakasi/Text-Kakasi-2.40.0-r1.ebuild,v 1.1 2014/08/22 20:25:38 axs Exp $

EAPI=5

MODULE_AUTHOR=DANKOGAI
MODULE_VERSION=2.04
inherit perl-module

DESCRIPTION="This module provides libkakasi interface for Perl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=">=app-i18n/kakasi-2.3.4"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/Text-Kakasi-1.05-gentoo.diff )
