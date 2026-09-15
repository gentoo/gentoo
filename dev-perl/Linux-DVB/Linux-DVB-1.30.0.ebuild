# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Interface to (some parts of) the Linux DVB API"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

DEPEND="sys-kernel/linux-headers"
BDEPEND=">=dev-perl/Canary-Stability-2001.0.0"

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.0-linux-headers.patch
)
