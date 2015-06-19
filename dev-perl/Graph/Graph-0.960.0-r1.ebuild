# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Graph/Graph-0.960.0-r1.ebuild,v 1.1 2014/08/22 20:49:27 axs Exp $

EAPI=5

MODULE_AUTHOR=JHI
MODULE_VERSION=0.96
inherit perl-module

DESCRIPTION="Data structure and ops for directed graphs"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-2.05"
DEPEND="${RDEPEND}"

SRC_TEST="do"
