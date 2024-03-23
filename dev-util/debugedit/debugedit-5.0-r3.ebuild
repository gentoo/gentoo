# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools verify-sig

DESCRIPTION="Create debuginfo and source file distributions"
HOMEPAGE="https://sourceware.org/debugedit/"
SRC_URI="
	https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz
	verify-sig? ( https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz.sig )
"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-libs/elfutils-0.176-r1
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
	verify-sig? (
		sec-keys/openpgp-keys-debugedit
	)
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/debugedit.gpg

PATCHES=(
	"${FILESDIR}"/${P}-readelf.patch
	"${FILESDIR}"/${P}-zero-dir-entry.patch
	"${FILESDIR}"/${P}-hppa.patch
	"${FILESDIR}"/${P}-musl-error.h-fix.patch

	# Upstreamed, remove next release
	"${FILESDIR}"/${P}-musl-1.2.4.patch
	# From upstream, remove next release
	"${FILESDIR}"/${P}-dw-form-strx-support.patch
)

src_prepare() {
	default
	eautoreconf
}
