# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
AUTOTOOLS_AUTO_DEPEND=no
AT_NOEAUTOHEADER=yes  # because expat_config.h.in would need post-processing
inherit autotools multilib-minimal

DESCRIPTION="Stream-oriented XML parser library"
HOMEPAGE="https://libexpat.github.io/"
SRC_URI="https://github.com/libexpat/libexpat/releases/download/R_${PV//\./_}/expat-${PV}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples static-libs test unicode"
RESTRICT="!test? ( test )"
BDEPEND="unicode? ( ${AUTOTOOLS_DEPEND} )"

DOCS=( README.md )

src_prepare() {
	default

	# fix interpreter to be a recent/good shell
	sed -i -e "1s:/bin/sh:${BASH}:" conftools/get-version.sh || die
	if use unicode; then
		cp -R "${S}" "${S}"w || die
		pushd "${S}"w >/dev/null
		find -name Makefile.am \
			-exec sed \
			-e 's,libexpat\.la,libexpatw.la,' \
			-e 's,libexpat_la,libexpatw_la,' \
			-i {} + || die
		eautoreconf
		popd >/dev/null
	fi
}

multilib_src_configure() {
	local myconf="$(use_with test tests) $(use_enable static-libs static) --without-docbook"

	mkdir -p "${BUILD_DIR}"w || die

	if use unicode; then
		pushd "${BUILD_DIR}"w >/dev/null
		CPPFLAGS="${CPPFLAGS} -DXML_UNICODE" ECONF_SOURCE="${S}"w econf ${myconf}
		popd >/dev/null
	fi

	ECONF_SOURCE="${S}" econf ${myconf}
}

multilib_src_compile() {
	emake

	if use unicode; then
		pushd "${BUILD_DIR}"w >/dev/null
		emake -C lib
		popd >/dev/null
	fi
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	if use unicode; then
		pushd "${BUILD_DIR}"w >/dev/null
		emake -C lib install DESTDIR="${D}"
		popd >/dev/null

		pushd "${ED}"/usr/$(get_libdir)/pkgconfig >/dev/null
		cp expat.pc expatw.pc
		sed -i -e '/^Libs/s:-lexpat:&w:' expatw.pc || die
		popd >/dev/null
	fi
}

multilib_src_install_all() {
	einstalldocs

	doman doc/xmlwf.1

	# Note: Use of HTML_DOCS would add unwanted "doc" subfolder
	docinto html
	dodoc doc/*.{css,html}

	if use examples; then
		docinto examples
		dodoc examples/*.c
		docompress -x usr/share/doc/${PF}/examples
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
