# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RBERJON
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Filter to put all characters() in one event"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/XML-SAX-0.12
"
BDEPEND="${RDEPEND}"
