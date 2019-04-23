# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HANK
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl interface to the GNU Aspell Library"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="app-text/aspell"
DEPEND="${RDEPEND}"
PERL_RM_FILES=( "t/02-pod.t" )
