# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PMQS
DIST_VERSION=2.213

inherit perl-module

DESCRIPTION="Perl interface for reading and writing lzma, lzip, and xz files/buffers"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}"
