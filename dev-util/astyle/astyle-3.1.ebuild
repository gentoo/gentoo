# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs versionator java-pkg-opt-2

DESCRIPTION="Artistic Style is a re-indenter and reformatter for C++, C and Java source code"
HOMEPAGE="http://astyle.sourceforge.net/"
SRC_URI="mirror://sourceforge/astyle/astyle_${PV}_linux.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
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

	# ex: libastyle.so.3.0.1
	dolib.so lib${PN}.so.${PV}.0
	# ex: libastyle.so.3
	dosym lib${PN}.so.${PV}.0 /usr/$(get_libdir)/lib${PN}.so.$(get_major_version)
	if use java ; then
		dolib.so lib${PN}j.so.${PV}
		dosym lib${PN}j.so.${PV} /usr/$(get_libdir)/lib${PN}j.so.$(get_major_version)
	fi
	if use static-libs ; then
		dolib lib${PN}.a
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
		elog "${ROOT}usr/share/doc/${P}/html"
	fi
}
