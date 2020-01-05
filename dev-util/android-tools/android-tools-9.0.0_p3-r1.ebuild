# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_{6,7} )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit flag-o-matic bash-completion-r1 ninja-utils toolchain-funcs cmake-utils python-r1

MY_PV="${PV/_p/_r}"
MY_P=${PN}-${MY_PV}

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://android.googlesource.com/platform/system/core.git/"
# See helper scripts in files/ for creating these tarballs and getting this hash.
BORINGSSL_SHA1="45210dd4e21ace9d28cb76b3f83303fcdd2efcce"
GLIBC_GETTID_PATCH="${P}-fix-build-with-glibc-2.30.patch"
# The ninja file was created by running the ruby script from archlinux by hand and fixing the build vars.
# No point in depending on something large/uncommon like ruby just to generate a ninja file.
SRC_URI="https://git.archlinux.org/svntogit/community.git/snapshot/community-0ffb7b41d599741d100a6a00a4bb20e162cd3f90.tar.xz -> ${MY_P}-arch.tar.xz
	https://github.com/android/platform_system_core/archive/android-${MY_PV}.tar.gz -> ${MY_P}-core.tar.gz
	https://github.com/google/boringssl/archive/${BORINGSSL_SHA1}.tar.gz -> boringssl-${BORINGSSL_SHA1}.tar.gz
	mirror://gentoo/${MY_P}-e2fsprogs.tar.xz https://dev.gentoo.org/~zmedico/dist/${MY_P}-e2fsprogs.tar.xz
	mirror://gentoo/${MY_P}-extras.tar.xz https://dev.gentoo.org/~zmedico/dist/${MY_P}-extras.tar.xz
	mirror://gentoo/${MY_P}-selinux.tar.xz https://dev.gentoo.org/~zmedico/dist/${MY_P}-selinux.tar.xz
	mirror://gentoo/${MY_P}-f2fs-tools.tar.xz https://dev.gentoo.org/~zmedico/dist/${MY_P}-f2fs-tools.tar.xz
	mirror://gentoo/${MY_P}.ninja.xz https://dev.gentoo.org/~zmedico/dist/${MY_P}.ninja.xz
	https://raw.githubusercontent.com/nmeum/android-tools/8a30dba5768304176fd78aaa131242f6b880f828/patches/core/0022-Use-glibc-s-gettid-when-using-glibc-2.30.patch -> ${GLIBC_GETTID_PATCH}"

# The entire source code is Apache-2.0, except for fastboot which is BSD-2.
LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~x86-linux"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

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
	unpack_into "${MY_P}-arch.tar.xz" arch
	unpack_into "${MY_P}-core.tar.gz" core
	unpack_into "${MY_P}-e2fsprogs.tar.xz" ./e2fsprogs
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
	sed -e 's:elseif (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "i386"):\0\n  set(ARCH "x86")\nelseif (${CMAKE_SYSTEM_PROCESSOR} STREQUAL "i586"):' \
		-i "${S}"/boringssl/CMakeLists.txt || die #668792

	cd "${S}"/core || die
	eapply "${WORKDIR}"/arch/trunk/fix_build_core.patch
	eapply "${FILESDIR}"/android-tools-8.1.0_p1-build.patch
	eapply "${DISTDIR}/${GLIBC_GETTID_PATCH}"

	cd "${S}"/selinux || die
	eapply "${WORKDIR}"/arch/trunk/fix_build_selinux.patch

	cd "${S}"/e2fsprogs || die
	eapply "${WORKDIR}"/arch/trunk/fix_build_e2fsprogs.patch

	cd "${S}"/extras
	sed -e 's|^#include <sys/cdefs.h>$|/*\0*/|' \
		-e 's|^__BEGIN_DECLS$|#ifdef __cplusplus\nextern "C" {\n#endif|' \
		-e 's|^__END_DECLS$|#ifdef __cplusplus\n}\n#endif|' \
		-i ext4_utils/include/ext4_utils/ext4_crypt{,_init_extensions}.h || die #580686

	cd "${S}" || die
	default

	sed -E \
		-e "s|^(CC =).*|\\1 $(tc-getCC)|g" \
		-e "s|^(CXX =).*|\\1 $(tc-getCXX)|g" \
		-e "s|^(CFLAGS =).*|\\1 ${CFLAGS}|g" \
		-e "s|^(CPPFLAGS =).*|\\1 ${CPPFLAGS}|g" \
		-e "s|^(CXXFLAGS =).*|\\1 ${CXXFLAGS}|g" \
		-e "s|^(LDFLAGS =).*|\\1 ${LDFLAGS}|g" \
		-e "s|^(PKGVER =).*|\\1 ${MY_PV}|g" \
		-i build.ninja || die

	# The pregenerated ninja file expects the build/ dir.
	BUILD_DIR="${CMAKE_USE_DIR}/build"
	cmake-utils_src_prepare
}

src_configure() {
	append-lfs-flags

	cmake-utils_src_configure
}

src_compile() {
	# We only need a few libs from boringssl.
	cmake-utils_src_compile libcrypto.a libssl.a

	eninja
}

src_install() {
	dobin adb e2fsdroid ext2simg fastboot mke2fs.android
	dodoc core/adb/*.{txt,TXT} core/fastboot/README.md
	use python && python_foreach_impl python_doexe core/mkbootimg/mkbootimg
	newbashcomp arch/trunk/bash_completion.fastboot fastboot
}
