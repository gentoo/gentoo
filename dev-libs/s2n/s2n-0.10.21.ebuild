# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="simple, small, fast and secure C99 implementation of the TLS/SSL protocols"
HOMEPAGE="https://github.com/awslabs/s2n"
SRC_URI="https://github.com/awslabs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl static-libs test"

RESTRICT="!test? ( test )"

RDEPEND="
	!libressl? ( dev-libs/openssl:0=[static-libs=] )
	libressl? ( dev-libs/libressl:0=[static-libs=] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# Fix
	# QA Notice: The following files contain writable and executable sections (...)
	sed \
		-e '$a\\n#if defined(__linux__) && defined(__ELF__)\n.section .note.GNU-stack,"",%progbits\n#endif' \
		-i "${S}"/pq-crypto/sike_r2/fp_x64_asm.S || die "sed failed"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
