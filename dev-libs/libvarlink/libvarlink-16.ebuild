# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="C implementation of the Varlink protocol and command line tool"
HOMEPAGE="https://github.com/varlink/libvarlink"
SRC_URI="https://github.com/varlink/libvarlink/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dtests="$(usex test true false)"
	)
	meson_src_configure
}
