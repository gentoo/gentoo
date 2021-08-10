# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}

inherit cmake-utils llvm

# This is a hog: We need to carve ObjCMetadata out of Apple's clang. We also
# need llvm-tblgen and clang-tblgen because tapi uses them to generate some
# source. It's assumed that they're only ever needed when building LLVM and
# clang. So they don't get installed in the system and we need to compile them
# fresh from LLVM and clang sources. And finally we need an installed LLVM and
# clang to build tapi against.

LLVM_PV=5.0.1
LLVM_PN=llvm
LLVM_P=${LLVM_PN}-${LLVM_PV}

CLANG_PN=cfe
CLANG_P=${CLANG_PN}-${LLVM_PV}

APPLE_LLVM_PV=800.0.42.1
APPLE_LLVM_PN=clang
APPLE_LLVM_P=${APPLE_LLVM_PN}-${APPLE_LLVM_PV}

OBJCMD_PN=objcmetadata
OBJCMD_P=${OBJCMD_PN}-${APPLE_LLVM_PV}

DESCRIPTION="Text-based Application Programming Interface"
HOMEPAGE="https://opensource.apple.com/source/tapi"
SRC_URI="https://opensource.apple.com/tarballs/clang/${APPLE_LLVM_P}.tar.gz
	http://releases.llvm.org/${LLVM_PV}/${LLVM_P}.src.tar.xz
	http://releases.llvm.org/${LLVM_PV}/${CLANG_P}.src.tar.xz"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/ributzka/tapi.git"
	TAPI_P=${P}
	inherit git-r3
else
	TAPI_COMMIT=b9205695b4edee91000383695be8de5ba8e0db41
	SRC_URI+=" https://github.com/ributzka/${PN}/archive/${TAPI_COMMIT}.tar.gz -> ${P}.tar.gz"
	TAPI_P=${PN}-${TAPI_COMMIT}
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~x64-macos"

DEPEND="sys-devel/llvm:=
	sys-devel/clang:="
RDEPEND="${DEPEND}"

DOCS=( Readme.md )

LLVM_S="${WORKDIR}"/${LLVM_P}.src
LLVM_BUILD="${WORKDIR}"/${LLVM_P}_build

CLANG_S="${WORKDIR}"/${CLANG_P}.src

APPLE_LLVM_S="${WORKDIR}/${APPLE_LLVM_P}"/src

S="${WORKDIR}"/${TAPI_P}

TAPI_BUILD="${WORKDIR}"/${P}_build

OBJCMD_S="${WORKDIR}"/${OBJCMD_P}
OBJCMD_BUILD="${WORKDIR}"/${OBJCMD_P}_build
# put temporary install root into tapi build dir so that it does not end up on
# libtapi's rpath
OBJCMD_ROOT="${TAPI_BUILD}"/${OBJCMD_PN}_root

src_prepare() {
	# carve ObjCMetadata out of llvm and make it stand on its own
	mkdir -p "${OBJCMD_S}"/{include/llvm,lib} || die
	cd ${OBJCMD_S} || die
	cp -r ${APPLE_LLVM_S}/include/llvm/ObjCMetadata include/llvm || die
	cp -r ${APPLE_LLVM_S}/lib/ObjCMetadata lib || die
	eapply "${FILESDIR}"/${OBJCMD_PN}-800.0.42.1-standalone.patch
	CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_prepare

	cd "${LLVM_S}" || die
	CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_prepare

	cd "${S}" || die
	eapply "${FILESDIR}"/${PN}-2.0.0-standalone.patch
	CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_prepare
}

src_configure() {
	# configure LLVM and clang for tablegen build
	local mycmakeargs=(
		# shared libs cause all kinds of problems and we don't need them just
		# to run tblgen a couple of times
		-DBUILD_SHARED_LIBS=OFF
		# configure less targets to speed up configuration. We don't build them
		# anyway.
		-DLLVM_TARGETS_TO_BUILD=X86
		-DLLVM_EXTERNAL_PROJECTS=clang
		-DLLVM_EXTERNAL_CLANG_SOURCE_DIR=${CLANG_S}
	)

	cd "${LLVM_S}" || die
	BUILD_DIR="${LLVM_BUILD}" \
		CMAKE_USE_DIR="${PWD}" \
		CMAKE_BUILD_TYPE=RelWithDebInfo \
		cmake-utils_src_configure

	local llvm_prefix=$(get_llvm_prefix)

	# configure ObjCMetadata
	local mycmakeargs=(
		# fails to compile without -std=c++11
		-DCMAKE_CXX_STANDARD=11
		# compile against currently installed LLVM
		-DLLVM_DIR="${llvm_prefix}/lib/cmake/llvm"
		# install into temporary root in work dir just so we can compile and
		# link against it. Static lib will be pulled into libtapi and tools.
		-DCMAKE_INSTALL_PREFIX="${OBJCMD_ROOT}"
	)

	cd "${OBJCMD_S}" || die
	BUILD_DIR="${OBJCMD_BUILD}" \
		CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_configure

	# configure tapi
	local mycmakeargs=(
		# fails to compile without -std=c++11
		-DCMAKE_CXX_STANDARD=11
		# compile against currently installed LLVM
		-DLLVM_DIR="${llvm_prefix}"/lib/cmake/llvm
		# use tblgens from LLVM build directory directly. They generate source
		# from description files. Therefore it shouldn't matter if they
		# match up with the installed LLVM.
		-DLLVM_TABLEGEN_EXE="${LLVM_BUILD}"/bin/llvm-tblgen
		-DCLANG_TABLEGEN_EXE="${LLVM_BUILD}"/bin/clang-tblgen
		# pull in includes and libs from ObjCMetadata's temporary install root
		-DOBJCMETADATA_INCLUDE_DIRS="${OBJCMD_ROOT}"/include
		-DOBJCMETADATA_LIBRARY_DIRS="${OBJCMD_ROOT}"/lib
	)

	cd "${S}" || die
	BUILD_DIR="${TAPI_BUILD}/" \
		CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_configure
}

src_compile() {
	# build LLVM and clang tablegen
	cd "${LLVM_S}" || die
	BUILD_DIR="${LLVM_BUILD}" \
		CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_compile llvm-tblgen clang-tblgen

	# build ObjCMetadata
	cd "${OBJCMD_S}" || die
	BUILD_DIR="${OBJCMD_BUILD}" \
		CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_compile
	# install into temporary root in work dir
	cd "${OBJCMD_BUILD}" || die
		${CMAKE_MAKEFILE_GENERATOR} install

	# finally build tapi
	cd "${S}" || die
	BUILD_DIR="${TAPI_BUILD}" \
		CMAKE_USE_DIR="${PWD}" \
		cmake-utils_src_compile
}
