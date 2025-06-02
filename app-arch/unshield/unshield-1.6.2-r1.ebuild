# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="InstallShield CAB file extractor"
HOMEPAGE="https://github.com/twogood/unshield"
SRC_URI="https://github.com/twogood/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"

DEPEND="
	dev-libs/openssl:0=
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# OpenSSL is detected at build time, and used to determine
		# whether or not a hand-rolled md5 implementation is used. The build
		# system prefers OpenSSL's implementation if it's available, and OpenSSL
		# is common enough, so we prefer it too. Since the dependency is
		# automagic (there's no way to hide it), we require OpenSSL
		# unconditionally.
		-DUSE_OUR_OWN_MD5=OFF
		# test not included in tar file
		# TODO: check in future releases
		-DBUILD_TESTING=OFF
	)

	cmake_src_configure
}
