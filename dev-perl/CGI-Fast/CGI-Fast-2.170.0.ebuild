# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEEJO
DIST_VERSION=2.17
inherit perl-module

DESCRIPTION="CGI Interface for Fast CGI"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~m68k ~mips ppc ~ppc64 ~riscv ~s390 x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/CGI-4
	>=dev-perl/FCGI-0.670.0
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/006_changes.t" )
