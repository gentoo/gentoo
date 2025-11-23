# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Signal Protocol C Library"
HOMEPAGE="https://signal.org/ https://github.com/signalapp/libsignal-protocol-c"
SRC_URI="https://github.com/signalapp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 arm64 x86"

LICENSE="GPL-3"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${PN}-2.3.3-CVE-2022-48468.patch
)
