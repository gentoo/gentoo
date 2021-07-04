# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake python-r1

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://github.com/nmeum/android-tools/ https://developer.android.com/"

MY_PV="${PV//_/}"
SRC_URI="https://github.com/nmeum/android-tools/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.xz
	https://github.com/mid-kid/android-tools/commit/32d76cdbeb8a4fc2bb5fe22f496a9b82b68305a3.patch -> ${PN}-no-gtest.patch
	https://github.com/mid-kid/android-tools/commit/9806fe4b730e15027ace235c62e166ae6148df56.patch -> ${PN}-fix-gcc11.patch
	https://github.com/mid-kid/android-tools/commit/557182ba3f912327e747c3c3638d6ee7c529fb96.patch -> ${PN}-dont-install-license.patch
	https://github.com/mid-kid/android-tools/commit/5971ec8ebab527fa17c91eaebe012d2a89a838db.patch -> ${PN}-install-e2fsdroid-ext2simg.patch
"
S="${WORKDIR}/${PN}-${MY_PV}"

# The entire source code is Apache-2.0, except for fastboot which is BSD-2.
LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~x86-linux"
IUSE="python"
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
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	dev-lang/go
"

DOCS=()

src_prepare() {
	eapply "${DISTDIR}/${PN}-no-gtest.patch"
	cd "${S}/vendor/core" || die
	eapply "${S}/patches/core/0011-Remove-the-useless-dependency-on-gtest.patch"
	cd "${S}/vendor/libziparchive" || die
	eapply "${S}/patches/libziparchive/0004-Remove-the-useless-dependency-on-gtest.patch"
	cd "${S}"
	eapply "${DISTDIR}/${PN}-fix-gcc11.patch"
	cd "${S}/vendor/boringssl" || die
	eapply "${S}/patches/boringssl/0001-Fix-mismatch-between-header-and-implementation-of-bn_sqr_comba8.patch"
	eapply "${S}/patches/boringssl/0002-Use-an-unsized-helper-for-truncated-SHA-512-variants.patch"
	eapply "${S}/patches/boringssl/0003-Fix-unnecessarily-direction-specific-tests-in-cipher_tests.txt.patch"
	eapply "${S}/patches/boringssl/0004-Test-empty-EVP_CIPHER-inputs-and-fix-exact-memcpy-overlap.patch"
	eapply "${S}/patches/boringssl/0005-Make-words-in-crypto-fipsmodule-modes-actually-words.patch"
	eapply "${S}/patches/boringssl/0006-Move-load-store-helpers-to-crypto-internal.h.patch"
	eapply "${S}/patches/boringssl/0007-Fold-ripemd-internal.h-into-ripemd.c.patch"
	eapply "${S}/patches/boringssl/0008-Pull-HASH_TRANSFORM-out-of-md32_common.h.patch"
	eapply "${S}/patches/boringssl/0009-Make-md32_common.h-single-included-and-use-an-unsized-helper-for-SHA-256.patch"
	eapply "${S}/patches/boringssl/0010-Fix-array-parametes-warnings.patch"
	cd "${S}"
	eapply "${DISTDIR}/${PN}-dont-install-license.patch"
	eapply "${DISTDIR}/${PN}-install-e2fsdroid-ext2simg.patch"
	rm -r patches || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Statically link the bundled boringssl
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
	use python && python_foreach_impl python_newexe vendor/mkbootimg/mkbootimg.py mkbootimg
	docinto adb
	dodoc vendor/adb/*.{txt,TXT}
	docinto fastboot
	dodoc vendor/core/fastboot/README.md
}
