# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu"
SRC_URI="
	https://dev.yorhel.nl/download/${P}.tar.gz
	verify-sig? ( https://dev.yorhel.nl/download/${P}.tar.gz.asc )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-lang/perl
	verify-sig? ( sec-keys/openpgp-keys-yorhel )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/yoranheling.asc
