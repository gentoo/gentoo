# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MNOONING
DIST_SECTION=${PN}
DIST_VERSION=0.2020
inherit perl-module

S=${WORKDIR}/${PN}

DESCRIPTION="The Perl RPC Module"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND=">=virtual/perl-Storable-1.0.7
	>=dev-perl/Net-Daemon-0.34"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.2020-no-perldoc.patch"
	"${FILESDIR}/Security-notice-on-Storable-and-reply-attack.patch"
	"${FILESDIR}/${PN}-0.2020-no-dot-inc.patch"
)

DIST_TEST="do" # Parallel testing fails
