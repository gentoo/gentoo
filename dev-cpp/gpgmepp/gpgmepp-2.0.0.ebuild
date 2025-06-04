# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
inherit cmake verify-sig

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use (C++ bindings)"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="
	mirror://gnupg/${PN}/${P}.tar.xz
	verify-sig? ( mirror://gnupg/${PN}/${P}.tar.xz.sig )
"

LICENSE="LGPL-2+ test? ( GPL-2 GPL-2+ LGPL-2.1+ )"
SLOT="0/7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<app-crypt/gpgme-2[cxx(-)]

	>=app-crypt/gpgme-${PV%.*}:=
	>=dev-libs/libgpg-error-1.47:=
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gnupg )"

src_configure() {
	local mycmakeargs=(
		# As of 2.0.0, there aren't any non-manual tests. tests/README
		# says that the real testing is done via dev-libs/qgpgme instead.
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
