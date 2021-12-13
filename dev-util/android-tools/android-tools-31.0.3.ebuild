# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit cmake python-r1

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://github.com/nmeum/android-tools/ https://developer.android.com/"

MY_PV="${PV//_/}"
SRC_URI="https://github.com/nmeum/android-tools/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.xz
	https://dev.gentoo.org/~zmedico/dist/${P}-no-gtest.patch
	https://dev.gentoo.org/~zmedico/dist/${P}-install-e2fsdroid-ext2simg.patch
	https://dev.gentoo.org/~zmedico/dist/${P}-disable-werror-boringssl.patch
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
	eapply "${DISTDIR}/${P}-no-gtest.patch"
	cd "${S}/vendor/core" || die
	eapply "${S}/patches/core/0011-Remove-the-useless-dependency-on-gtest.patch"
	cd "${S}/vendor/libziparchive" || die
	eapply "${S}/patches/libziparchive/0004-Remove-the-useless-dependency-on-gtest.patch"
	cd "${S}"
	eapply "${DISTDIR}/${P}-install-e2fsdroid-ext2simg.patch"
	eapply "${DISTDIR}/${P}-disable-werror-boringssl.patch"
	cd "${S}/vendor/boringssl" || die
	eapply "${S}/patches/boringssl/0011-Disable-Werror.patch"
	cd "${S}"
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
