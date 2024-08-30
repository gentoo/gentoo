# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib java-pkg-opt-2

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://github.com/libjpeg-turbo/libjpeg-turbo"
SRC_URI="
	https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/${PV}/${P}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz
"

LICENSE="BSD IJG ZLIB java? ( GPL-2-with-classpath-exception )"
SLOT="0/0.2"
if [[ $(ver_cut 3) -lt 90 ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos ~x64-solaris"
fi
IUSE="cpu_flags_arm_neon java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"
COMMON_DEPEND="
	!media-libs/jpeg:0
	!media-libs/jpeg:62
"
DEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jdk-1.8:*[-headless-awt] )
"
RDEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
BDEPEND="
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

src_prepare() {
	local FILE
	ln -snf ../debian/extra/*.c . || die

	for FILE in ../debian/extra/*.c; do
		FILE=${FILE##*/}
		cat >> CMakeLists.txt <<-EOF || die
		add_executable(${FILE%.c} ${FILE})
		install(TARGETS ${FILE%.c})
		EOF
	done

	cmake_src_prepare
	java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	if multilib_is_native_abi && use java ; then
		export JAVAFLAGS="$(java-pkg_javac-args)"
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_STATIC="$(usex static-libs)"
		-DWITH_JAVA="$(multilib_native_usex java)"
	)

	# Avoid ARM ABI issues by disabling SIMD for CPUs without NEON, bug #792810
	if use arm || use arm64; then
		mycmakeargs+=(
			-DWITH_SIMD=$(usex cpu_flags_arm_neon)
			-DNEON_INTRINSICS=$(usex cpu_flags_arm_neon)
		)
	fi

	# We should tell the test suite which floating-point flavor we are
	# expecting: https://github.com/libjpeg-turbo/libjpeg-turbo/issues/597
	# For now, mark loong as fp-contract.
	if use loong; then
		mycmakeargs+=(
			-DFLOATTEST=fp-contract
		)
	fi

	# Mostly for Prefix, ensure that we use our yasm if installed and
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
	dobin "${WORKDIR}"/debian/extra/exifautotran
	doman "${WORKDIR}"/debian/extra/*.[0-9]*

	docinto html
	dodoc -r "${S}"/doc/html/.

	if use java; then
		docinto html/java
		dodoc -r "${S}"/java/doc/.
		newdoc "${S}"/java/README README.java
	fi
}
