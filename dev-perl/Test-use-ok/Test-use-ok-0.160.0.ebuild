# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-use-ok/Test-use-ok-0.160.0.ebuild,v 1.1 2015/06/20 20:12:38 dilfridge Exp $

EAPI=5

DESCRIPTION="Alternative to Test::More::use_ok"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.gentoo.org/"
LICENSE="GPL-2"
# this is just a dummy ebuild to help with portage dependency resolution on
# Perl 5.22 upgrade - it does not install any files

RDEPEND="~virtual/perl-Test-Simple-1.1.14"
