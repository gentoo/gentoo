# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Application automation framework"
HOMEPAGE="https://github.com/habitat-sh/habitat https://habitat.sh"
SRC_URI="https://github.com/habitat-sh/habitat/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~mrueg/files/${PN}-cargo-${PV}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=net-libs/zeromq-3.2
	virtual/pkgconfig
	>=virtual/rust-1.23"

RESTRICT="test"

src_prepare() {
	default
	# move cache dir where cargo expects it
	mv ../.cargo "${HOME}" || die
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobin target/debug/hab{,-butterfly,-sup}
}

src_test() {
	emake unit-all
}
