# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-AutoInstall/ExtUtils-AutoInstall-0.630.0-r1.ebuild,v 1.1 2014/08/22 21:28:24 axs Exp $

EAPI=5

MODULE_AUTHOR=AUTRIJUS
MODULE_VERSION=0.63
inherit perl-module

DESCRIPTION="Allows module writers to specify a more sophisticated form of dependency information"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

# TESTS BAD. Wants to write to cpan's config on the live system
#SRC_TEST="do"

RDEPEND="dev-perl/Sort-Versions"
DEPEND="${RDEPEND}"

src_compile() {
	echo "n" | perl-module_src_compile
}
