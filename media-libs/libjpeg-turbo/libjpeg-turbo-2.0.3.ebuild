# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib java-pkg-opt-2 libtool toolchain-funcs

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/libjpeg8_8d-2.debian.tar.gz"

LICENSE="BSD IJG"
SLOT="0"
[[ "$(ver_cut 3)" -ge 90 ]] || \
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"
COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.5 )"
DEPEND="${COMMON_DEPEND}
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )
	java? ( >=virtual/jdk-1.5 )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/jconfig.h )

src_prepare() {
	default

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
	[[ ${ABI} == "x32" ]] && mycmakeargs+=( -DREQUIRE_SIMD=OFF ) #420239
	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile

	if multilib_is_native_abi ; then
		pushd "${WORKDIR}/debian/extra" &>/dev/null || die
		emake CC="$(tc-getCC)" CFLAGS="${LDFLAGS} ${CFLAGS}"
		popd &>/dev/null || die
	fi
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi ; then
		pushd "${WORKDIR}/debian/extra" &>/dev/null || die
		emake \
			DESTDIR="${D}" prefix="${EPREFIX}"/usr \
			INSTALL="install -m755" INSTALLDIR="install -d -m755" \
			install

		popd || die
		if use java ; then
			rm -rf "${ED%/}"/usr/classes || die
			java-pkg_dojar java/turbojpeg.jar
		fi
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name '*.la' -delete || die

	insinto /usr/share/doc/${PF}/html
	doins -r "${S}"/doc/html/*
	newdoc "${WORKDIR}"/debian/changelog changelog.debian
	if use java; then
		insinto /usr/share/doc/${PF}/html/java
		doins -r "${S}"/java/doc/*
		newdoc "${S}"/java/README README.java
	fi
}
