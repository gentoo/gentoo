# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc
inherit cmake verify-sig

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use (Qt bindings)"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="
	mirror://gnupg/${PN}/${P}.tar.xz
	verify-sig? ( mirror://gnupg/${PN}/${P}.tar.xz.sig )
"

LICENSE="GPL-2+ test? ( GPL-2 )"
SLOT="0/7"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=app-crypt/gpgme-${PV%.*}:=
	>=dev-cpp/gpgmepp-${PV%.*}:=
	>=dev-libs/libgpg-error-1.47:=
	>=dev-qt/qtbase-6.5.0:6
"
RDEPEND="${DEPEND}
	!<app-crypt/gpgme-2[qt6(-)]
	!dev-libs/qgpgme:1
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gnupg )"

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-typo.patch
	"${FILESDIR}"/${P}-ub.patch
	"${FILESDIR}"/${P}-ub-followup.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT5=OFF
		-DBUILD_WITH_QT6=ON
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}
