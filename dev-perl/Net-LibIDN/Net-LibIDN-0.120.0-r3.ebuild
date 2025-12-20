# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=THOR
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="net-dns/libidn:0="
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"
