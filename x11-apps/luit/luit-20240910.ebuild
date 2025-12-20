# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="Locale and ISO 2022 support for Unicode terminals"
HOMEPAGE="https://invisible-island.net/luit/"
SRC_URI="https://invisible-mirror.net/archives/${PN}/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${P}.tgz.asc )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

DEPEND="
	virtual/zlib:=
	virtual/libiconv
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/groff
	verify-sig? ( sec-keys/openpgp-keys-thomasdickey )
"

src_configure() {
	econf --disable-fontenc --enable-iconv
}
