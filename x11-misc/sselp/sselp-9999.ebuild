# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 toolchain-funcs

DESCRIPTION="Simple X selection printer"
HOMEPAGE="https://tools.suckless.org/x/sselp"
EGIT_REPO_URI="https://git.suckless.org/sselp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e "s|^CFLAGS = -std=c99 -pedantic -Wall -Os|CFLAGS += -std=c99 -pedantic -Wall|" \
		-e "s|^LDFLAGS = -s|LDFLAGS +=|" \
		-e "s|^CC = cc|CC = $(tc-getCC)|" \
		config.mk || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	einstalldocs
}
