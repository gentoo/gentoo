# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C implementation of Bitcoin's getblocktemplate interface"
HOMEPAGE="https://github.com/bitcoin/libblkmaker"
SRC_URI="https://github.com/bitcoin/${PN}/archive/v${PV}.tar.gz -> ${P}-github.tgz"

LICENSE="MIT"
SLOT="0/7"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/jansson-2.0.0:=
	dev-libs/libbase58
"
DEPEND="${RDEPEND}
	test? ( dev-libs/libgcrypt )
"

src_prepare() {
	default
	eautoreconf
}
