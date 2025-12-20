# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MZSANFORD
DIST_VERSION=0.61
inherit perl-module

DESCRIPTION="Access CPU info. number, etc on Win and UNIX"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.610.0-musl-unistd-h.patch
)
