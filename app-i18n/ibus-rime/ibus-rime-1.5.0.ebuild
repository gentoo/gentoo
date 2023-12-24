# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Chinese Rime Input Method Engine for IBus"
HOMEPAGE="https://rime.im/ https://github.com/rime/ibus-rime"
SRC_URI="https://github.com/rime/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	app-i18n/ibus
	app-i18n/librime
	app-i18n/rime-data
	x11-libs/libnotify"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/cmake
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e "/^libexecdir/s:/lib:/libexec:" \
		-e "/^[[:space:]]*PREFIX/s:/usr:${EPREFIX}/usr:" \
		-e "s/ make/ \$(MAKE)/" Makefile || die

	default
}
