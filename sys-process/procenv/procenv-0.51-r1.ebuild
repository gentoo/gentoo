# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="command-line utility to show process environment"
HOMEPAGE="https://github.com/jamesodhunt/procenv"
SRC_URI="https://github.com/jamesodhunt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/check )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.45-flags.patch
	"${FILESDIR}"/${PN}-0.51-musl-sysmacros.patch
)

src_prepare() {
	default
	eautoreconf
}
