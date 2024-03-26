# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="https://www.monkeysaudio.com"
SRC_URI="https://monkeysaudio.com/files/MAC_${PV/.}_SDK.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0/10"
KEYWORDS="~alpha ~amd64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

BDEPEND="app-arch/unzip"

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die
	default
}

CMAKE_BUILD_TYPE=Release

PATCHES=(
	"${FILESDIR}/${PN}-10.18-linux.patch"
	"${FILESDIR}/${PN}-10.52-output.patch"
)

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/927060
	#
	# Upstream contact method is via email. I sent an email detailing the issue
	# and got a fast response with a fix. "I'm hoping to do a build soon with a
	# new open source certificate.  I can sure include this."
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	cmake_src_configure
}
