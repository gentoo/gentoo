# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perl-Tags/Perl-Tags-0.280.0-r2.ebuild,v 1.1 2015/07/17 08:42:00 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=OSFAMERON
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="Generate (possibly exuberant) Ctags style tags for Perl sourcecode"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

PERL_RM_FILES=(
	t/05_vim.t
)

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/Module-Locate
	dev-perl/PPI
"
DEPEND="${RDEPEND}
	test? ( app-editors/vim[perl] )
"

SRC_TEST="do"
