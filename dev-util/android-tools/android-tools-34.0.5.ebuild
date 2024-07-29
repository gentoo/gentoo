# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake flag-o-matic python-r1

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://github.com/nmeum/android-tools/ https://developer.android.com/"

MY_PV="${PV//_/}"
SRC_URI="https://github.com/nmeum/android-tools/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.xz
	https://dev.gentoo.org/~zmedico/dist/${PN}-31.0.3-no-gtest.patch
"
S="${WORKDIR}/${PN}-${MY_PV}"

# The entire source code is Apache-2.0, except for fastboot which is BSD-2.
LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="python udev"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# dev-libs/libpcre only required for e2fsdroid
DEPEND="
	app-arch/brotli:=
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/libpcre2:=
	>=dev-libs/protobuf-3.0.0:=
	sys-libs/zlib:=
	virtual/libusb:1=
"
RDEPEND="${DEPEND}
	udev? ( dev-util/android-udev-rules )
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	dev-lang/go
	dev-lang/perl
"

DOCS=()

src_prepare() {
	eapply "${DISTDIR}/${PN}-31.0.3-no-gtest.patch"

	cd "${S}/vendor/core" || die
	eapply "${S}/patches/core/0011-Remove-the-useless-dependency-on-gtest.patch"

	cd "${S}/vendor/libziparchive" || die
	eapply "${S}/patches/libziparchive/0004-Remove-the-useless-dependency-on-gtest.patch"

	cd "${S}" || die

	# why do we depend on libandroidfw? It is never linked to or used.
	# https://github.com/nmeum/android-tools/issues/148
	sed -i '/libandroidfw/d' vendor/CMakeLists.txt || die
	rm -r vendor/base || die

	rm -r patches || die
	cmake_src_prepare
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	#
	# https://bugs.gentoo.org/858311
	# https://issuetracker.google.com/issues/347247969
	#
	# and in vendored f2fs-tools copy:
	# https://bugs.gentoo.org/863896
	filter-lto

	local mycmakeargs=(
		# Statically link the bundled boringssl
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_C_FLAGS="$CFLAGS" \
		-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON \
		-Dprotobuf_MODULE_COMPATIBLE=ON
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

src_compile() {
	export GOCACHE="${T}/go-build"
	export GOFLAGS="-mod=vendor"
	cmake_src_compile
}

src_install() {
	cmake_src_install
	rm "${ED}/usr/bin/mkbootimg" || die
	rm "${ED}/usr/bin/unpack_bootimg" || die
	rm "${ED}/usr/bin/repack_bootimg" || die
	rm "${ED}/usr/bin/mkdtboimg" || die
	rm "${ED}/usr/bin/avbtool" || die

	if use python; then
		python_foreach_impl python_newexe vendor/mkbootimg/mkbootimg.py mkbootimg
		python_foreach_impl python_newexe vendor/mkbootimg/unpack_bootimg.py unpack_bootimg
		python_foreach_impl python_newexe vendor/mkbootimg/repack_bootimg.py repack_bootimg
		python_foreach_impl python_newexe vendor/libufdt/utils/src/mkdtboimg.py mkdtboimg
		python_foreach_impl python_newexe vendor/avb/avbtool.py avbtool
	fi
	docinto adb
	dodoc vendor/adb/*.{txt,TXT}
	docinto fastboot
	dodoc vendor/core/fastboot/README.md
}
