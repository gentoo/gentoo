# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PMQS
DIST_VERSION=2.205

inherit perl-module

DESCRIPTION="Perl interface for reading and writing lzma, lzip, and xz files/buffers"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}"
