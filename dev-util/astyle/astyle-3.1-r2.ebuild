# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs versionator java-pkg-opt-2

DESCRIPTION="Artistic Style is a re-indenter and reformatter for C++, C and Java source code"
HOMEPAGE="http://astyle.sourceforge.net/"
SRC_URI="mirror://sourceforge/astyle/astyle_${PV}_linux.tar.gz"

LICENSE="MIT"
SLOT="0/3.1"
KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples java static-libs"

DEPEND="app-arch/xz-utils
	java? ( >=virtual/jdk-1.6:= )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	if use java ; then
		java-pkg-opt-2_src_prepare
		sed	-e "s:^\(JAVAINCS\s*\)=.*$:\1= $(java-pkg_get-jni-cflags):" \
			-e "s:ar crs:$(tc-getAR) crs:" \
			-i build/gcc/Makefile || die
	else
		default
	fi
}

src_configure() {
	append-cxxflags -std=c++11
	tc-export CXX
	default
}

src_compile() {
	# ../build/clang/Makefile is identical except for CXX line.
	emake CXX="$(tc-getCXX)" -f ../build/gcc/Makefile -C src \
		${PN} \
		shared \
		$(usev java) \
		$(usex static-libs static '')
}

src_install() {
	doheader src/${PN}.h

	pushd src/bin >/dev/null || die
	dobin ${PN}

	local libastylename="lib${PN}.so.${PV}.0"
	local libastylejname="lib${PN}j.so.${PV}.0"
	local libdestdir="/usr/$(get_libdir)"

	dolib.so "${libastylename}"
	dosym "${libastylename}" "${libdestdir}/lib${PN}.so.$(get_major_version)"
	dosym "${libastylename}" "${libdestdir}/lib${PN}.so"
	if use java ; then
		dolib.so "${libastylejname}"
		dosym "${libastylejname}" "${libdestdir}/lib${PN}j.so.$(get_major_version)"
		dosym "${libastylejname}" "${libdestdir}/lib${PN}j.so"
	fi
	if use static-libs ; then
		dolib.a lib${PN}.a
	fi
	popd >/dev/null || die
	if use examples ; then
		docinto examples
		dodoc -r file/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	local HTML_DOCS=( doc/. )
	einstalldocs
}

pkg_postinst() {
	if [[ -n "$REPLACING_VERSIONS" && "$(get_major_version $REPLACING_VERSIONS)" -lt 3 ]]; then
		elog "Artistic Style 3.0 introduces new configuration verbiage more fitting"
		elog "for modern use. Some options that were valid in 2.06 or older are now"
		elog "deprecated. For more information, consult astyle's release notes at"
		elog "http://astyle.sourceforge.net/news.html. To view offline, see:"
		elog
		elog "${EROOT%/}/usr/share/doc/${P}/html"
	fi
}
