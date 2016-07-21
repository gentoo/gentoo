# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Alternative to Test::More::use_ok"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="https://www.gentoo.org/"
LICENSE="GPL-2"
# this is just a dummy ebuild to help with portage dependency resolution on
# Perl 5.22 upgrade - it does not install any files

RDEPEND="~virtual/perl-Test-Simple-1.1.14"
