# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic pax-utils toolchain-funcs

MY_P=${PN}${PV/./}
DESCRIPTION="Journaling incremental deduplicating archiving compressor"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +jit"

# now 2in1!
RDEPEND="!app-arch/libzpaq"
# perl for pod2man
DEPEND="
	app-arch/unzip
	dev-lang/perl"

S=${WORKDIR}

src_prepare() {
	default
	sed -i -e '/^zpaq:/,+1s/libzpaq\.o/$(SONAME)/' Makefile || die
}

src_compile() {
	use debug || append-cppflags -DNDEBUG
	use jit || append-cppflags -DNOJIT
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}"
}

src_test() {
	local -x LD_LIBRARY_PATH=".${LD_LIBRARY_PATH+:${LD_LIBRARY_PATH}}"
	use jit && pax-mark m zpaq
	default
}

src_install() {
	emake install PREFIX="${ED%/}"/usr LIBDIR="\$(PREFIX)/$(get_libdir)"
	use jit && pax-mark m "${ED%/}"/usr/bin/zpaq
	einstalldocs
}

pkg_postinst() {
	if ! has_version app-arch/zpaq-extras; then
		elog "You may also want to install app-arch/zpaq-extras package which provides"
		elog "few additional configs and preprocessors for use with zpaq."
	fi
}
