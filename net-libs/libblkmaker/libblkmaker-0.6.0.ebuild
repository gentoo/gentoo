# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="C implementation of Bitcoin's getblocktemplate interface"
HOMEPAGE="https://github.com/bitcoin/libblkmaker"
LICENSE="MIT"

SRC_URI="https://github.com/bitcoin/${PN}/archive/v${PV}.tar.gz -> ${P}-github.tgz"
SLOT="0/7"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/jansson-2.0.0[${MULTILIB_USEDEP}]
	dev-libs/libbase58[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-libs/libgcrypt[${MULTILIB_USEDEP}] )
"

ECONF_SOURCE="${S}"

src_prepare() {
	default
	eautoreconf
}
