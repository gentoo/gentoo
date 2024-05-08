# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="High performance source code search tool"
HOMEPAGE="https://github.com/tkengo/highway"
SRC_URI="https://github.com/tkengo/highway/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	eautoreconf
}
