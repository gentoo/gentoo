# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit flag-o-matic bash-completion-r1 ninja-utils toolchain-funcs cmake-utils python-r1 python-utils-r1

MY_PV="${PV/_p/_r}"
MY_P=${PN}-${MY_PV}

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://android.googlesource.com/platform/system/core.git/"
# See helper scripts in files/ for creating these tarballs and getting this hash.
BORINGSSL_SHA1="14308731e5446a73ac2258688a9688b524483cb6"
# The ninja file was created by running the ruby script from archlinux by hand and fixing the build vars.
# No point in depending on something large/uncommon like ruby just to generate a ninja file.
SRC_URI="https://git.archlinux.org/svntogit/community.git/snapshot/community-2b7f9774cc468205fec145e64e9103aee8e5c6f9.tar.gz -> ${MY_P}-arch.tar.gz
	https://github.com/android/platform_system_core/archive/android-${MY_PV}.tar.gz -> ${MY_P}-core.tar.gz
	https://github.com/google/boringssl/archive/${BORINGSSL_SHA1}.tar.gz -> boringssl-${BORINGSSL_SHA1}.tar.gz
	mirror://gentoo/${MY_P}-extras.tar.xz https://dev.gentoo.org/~vapier/dist/${MY_P}-extras.tar.xz
	mirror://gentoo/${MY_P}-selinux.tar.xz https://dev.gentoo.org/~vapier/dist/${MY_P}-selinux.tar.xz
	mirror://gentoo/${MY_P}-f2fs-tools.tar.xz https://dev.gentoo.org/~vapier/dist/${MY_P}-f2fs-tools.tar.xz
	mirror://gentoo/${MY_P}.ninja.xz https://dev.gentoo.org/~vapier/dist/${MY_P}.ninja.xz"

# The entire source code is Apache-2.0, except for fastboot which is BSD-2.
LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~arm-linux ~x86-linux"
IUSE="python"

DEPEND="sys-libs/zlib:=
	dev-libs/libpcre2:=
	virtual/libusb:1="
RDEPEND="${DEPEND}
	python? ( ${PYTHON_DEPS} )"
DEPEND+="
	dev-lang/go"

S=${WORKDIR}
CMAKE_USE_DIR="${S}/boringssl"

unpack_into() {
	local archive="$1"
	local dir="$2"

	mkdir -p "${dir}"
	pushd "${dir}" >/dev/null || die
	unpack "${archive}"
	if [[ ${dir} != ./* ]] ; then
		mv */* ./ || die
	fi
	popd >/dev/null
}

src_unpack() {
	unpack_into "${MY_P}-arch.tar.gz" arch
	unpack_into "${MY_P}-core.tar.gz" core
	unpack_into "${MY_P}-extras.tar.xz" extras
	unpack_into "${MY_P}-f2fs-tools.tar.xz" ./f2fs-tools
	unpack_into "${MY_P}-selinux.tar.xz" ./selinux
	unpack_into boringssl-${BORINGSSL_SHA1}.tar.gz boringssl

	unpack "${MY_P}.ninja.xz"
	mv "${MY_P}.ninja" "build.ninja" || die

	# Avoid depending on gtest just for its prod headers when boringssl bundles it.
	ln -s ../../boringssl/third_party/googletest/include/gtest core/include/ || die
}

src_prepare() {
	cd "${S}"/core
	eapply "${WORKDIR}"/arch/trunk/fix_build_core.patch
	eapply "${FILESDIR}"/${P}-build.patch
	sed -i '1i#include <sys/sysmacros.h>' adb/client/usb_linux.cpp || die #616508

	cd "${S}"/selinux
	eapply "${WORKDIR}"/arch/trunk/fix_build_selinux.patch

	cd "${S}"/extras
	sed -e 's|^#include <sys/cdefs.h>$|/*\0*/|' \
		-e 's|^__BEGIN_DECLS$|#ifdef __cplusplus\nextern "C" {\n#endif|' \
		-e 's|^__END_DECLS$|#ifdef __cplusplus\n}\n#endif|' \
		-i ext4_utils/sha1.{c,h} || die #580686

	cd "${S}"
	default

	# The pregenerated ninja file expects the build/ dir.
	BUILD_DIR="${CMAKE_USE_DIR}/build"
	cmake-utils_src_prepare
}

src_configure() {
	append-lfs-flags

	cmake-utils_src_configure

	sed -i \
		-e "s:@CC@:$(tc-getCC):g" \
		-e "s:@CXX@:$(tc-getCXX):g" \
		-e "s:@CFLAGS@:${CFLAGS}:g" \
		-e "s:@CPPFLAGS@:${CPPFLAGS}:g" \
		-e "s:@CXXFLAGS@:${CXXFLAGS}:g" \
		-e "s:@LDFLAGS@:${LDFLAGS}:g" \
		-e "s:@PV@:${PV}:g" \
		build.ninja || die
}

src_compile() {
	# We only need a few libs from boringssl.
	cmake-utils_src_compile libcrypto.a libssl.a

	eninja
}

src_install() {
	dobin adb fastboot
	dodoc core/adb/*.{txt,TXT} core/fastboot/README.md
	use python && python_foreach_impl python_doexe core/mkbootimg/mkbootimg
	newbashcomp arch/trunk/bash_completion.fastboot fastboot
}
