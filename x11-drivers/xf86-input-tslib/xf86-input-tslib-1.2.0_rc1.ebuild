# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vcs-snapshot

DESCRIPTION="X.org tslib input driver"
HOMEPAGE="https://github.com/merge/xf86-input-tslib"
SRC_URI="https://github.com/merge/${PN}/archive/${PV/_rc/-rc}.tar.gz -> ${P}.tar.gz"
IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sh sparc x86"

RDEPEND="x11-libs/tslib
	x11-base/xorg-server:="
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( "README.md" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
