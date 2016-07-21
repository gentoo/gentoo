# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="https://taglib.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1 MPL-1.1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
SLOT="0"
IUSE="+asf debug examples +mp4 test"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	test? ( >=dev-util/cppunit-1.13.2[${MULTILIB_USEDEP}] )
"
RDEPEND="${RDEPEND}
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20140508-r2
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-install-examples.patch
	"${FILESDIR}"/${P}-missing-deletes.patch
	"${FILESDIR}"/${P}-order-big-endian.patch
	"${FILESDIR}"/${P}-abi-breakage.patch
	"${FILESDIR}"/${P}-bytevector-simpler.patch
)

DOCS=( AUTHORS NEWS )

MULTILIB_CHOST_TOOLS=(
	/usr/bin/taglib-config
)

multilib_src_configure() {
	mycmakeargs=(
		$(multilib_is_native_abi && cmake-utils_use_build examples)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_with asf)
		$(cmake-utils_use_with mp4)
	)

	cmake-utils_src_configure
}

multilib_src_test() {
	# ctest does not work
	emake -C "${BUILD_DIR}" check
}

pkg_postinst() {
	if ! use asf; then
		elog "You've chosen to disable the asf use flag, thus taglib won't include"
		elog "support for Microsoft's 'advanced systems format' media container"
	fi
	if ! use mp4; then
		elog "You've chosen to disable the mp4 use flag, thus taglib won't include"
		elog "support for the MPEG-4 part 14 / MP4 media container"
	fi
}
