# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="IPv4/6 round-robin multiping client"
HOMEPAGE="https://mping.uninett.no"
SRC_URI="https://mping.uninett.no/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/${P}-RFC3542.patch
)
