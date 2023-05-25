# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HANK
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl interface to the GNU Aspell Library"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="app-text/aspell"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/02-pod.t" )
