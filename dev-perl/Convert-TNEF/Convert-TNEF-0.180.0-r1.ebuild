# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DOUGW
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="A Perl module for reading TNEF files"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-perl/MIME-tools"
DEPEND="${RDEPEND}"

SRC_TEST=do
