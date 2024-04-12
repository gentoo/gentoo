# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A router configuration security analysis library"
HOMEPAGE="http://nipper.titania.co.uk/"
SRC_URI="https://downloads.sourceforge.net/nipper/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-glibc-2.10.patch"
	"${FILESDIR}/${P}-gcc47.patch"
	"${FILESDIR}/${P}-multilib-strict.patch"
	"${FILESDIR}/${P}-gcc12-time.patch"
	"${FILESDIR}/${P}-wformat-security.patch"
)
