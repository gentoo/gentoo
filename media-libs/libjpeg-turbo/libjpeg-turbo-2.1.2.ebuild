# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib java-pkg-opt-2

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0/0.2"
if [[ "$(ver_cut 3)" -lt 90 ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris ~x86-solaris"
fi
IUSE="cpu_flags_arm_neon java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"

COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"

BDEPEND=">=dev-util/cmake-3.16.5
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:*[-headless-awt] )"

RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

src_prepare() {
	local FILE
	ln -snf ../debian/extra/*.c . || die

	for FILE in ../debian/extra/*.c; do
		FILE=${FILE##*/}
		cat >> CMakeLists.txt <<EOF || die
add_executable(${FILE%.c} ${FILE})
install(TARGETS ${FILE%.c})
EOF
	done

	for FILE in ../debian/extra/exifautotran; do
		cat >> CMakeLists.txt <<EOF || die
install(FILES \${CMAKE_CURRENT_SOURCE_DIR}/${FILE} DESTINATION \${CMAKE_INSTALL_BINDIR})
EOF
	done

	for FILE in ../debian/extra/*.[0-9]*; do
		cat >> CMakeLists.txt <<EOF || die
install(FILES \${CMAKE_CURRENT_SOURCE_DIR}/${FILE} DESTINATION \${CMAKE_INSTALL_MANDIR}/man${FILE##*.})
EOF
	done

	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	if multilib_is_native_abi && use java ; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_STATIC="$(usex static-libs)"
		-DWITH_JAVA="$(multilib_native_usex java)"
		-DWITH_MEM_SRCDST=ON
	)

	# Avoid ARM ABI issues by disabling SIMD for CPUs without NEON. #792810
	if use arm; then
		mycmakeargs+=(
			-DWITH_SIMD:BOOL=$(usex cpu_flags_arm_neon ON OFF)
		)
	fi

	# mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	if has_version -b dev-lang/yasm && ! has_version -b dev-lang/nasm; then
		mycmakeargs+=(
			-DCMAKE_ASM_NASM_COMPILER=$(type -P yasm)
		)
	fi

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi && use java ; then
		rm -rf "${ED}"/usr/classes || die
		java-pkg_dojar java/turbojpeg.jar
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die

	local -a DOCS=( README.md ChangeLog.md )
	einstalldocs

	newdoc "${WORKDIR}"/debian/changelog changelog.debian

	docinto html
	dodoc -r "${S}"/doc/html/.

	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/.
		newdoc "${S}"/java/README README.java
	fi
}
