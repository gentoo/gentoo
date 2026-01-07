# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GRUBER
DIST_VERSION=1.23
inherit perl-module

DESCRIPTION="Patricia Trie perl module for fast IP address lookups"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="ipv6"

RDEPEND="
	dev-perl/Net-CIDR-Lite
	ipv6? (
		dev-perl/Socket6
	)
"
BDEPEND="${RDEPEND}"
