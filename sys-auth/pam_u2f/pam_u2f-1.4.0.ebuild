# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake pam

DESCRIPTION="PAM module for FIDO2 and U2F keys"
HOMEPAGE="https://github.com/Yubico/pam-u2f"
SRC_URI="https://developers.yubico.com/${PN/_/-}/Releases/${P}.tar.gz"

LICENSE="BSD ISC"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libfido2:=
	dev-libs/openssl:=
	sys-libs/pam
"
RDEPEND="${DEPEND}"
BDEPEND="app-text/asciidoc"

src_configure() {
	local mycmakeargs=(
		-DPAM_DIR=$(getpam_mod_dir)
	)
	if use test; then
		mycmakeargs+=(
			-DBUILD_TESTING=ON
		)
	else
		mycmakeargs+=(
			-DBUILD_TESTING=OFF
		)
	fi

	cmake_src_configure
}
