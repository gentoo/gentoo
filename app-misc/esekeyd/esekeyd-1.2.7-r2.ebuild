# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Multimedia key daemon that uses the Linux event interface"
HOMEPAGE="https://github.com/burghardt/esekeyd"
SRC_URI="https://github.com/burghardt/esekeyd/archive/refs/tags/${P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

PATCHES=(
	"${FILESDIR}/1.2.7-fix-revision.patch"
)

DOCS=( AUTHORS ChangeLog examples/example.conf NEWS README TODO )

src_prepare() {
	default
	eautoreconf
}
