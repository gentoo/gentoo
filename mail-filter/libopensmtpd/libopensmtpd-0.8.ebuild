# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Library for creating OpenSMTPD filters"
HOMEPAGE="https://src.imperialat.at/?action=summary&path=libopensmtpd.git"
SRC_URI="https://src.imperialat.at/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

src_prepare() {
	mv -f Makefile.gnu Makefile
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" MANFORMAT="man"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" MANFORMAT="man" install
}
