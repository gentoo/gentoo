# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="An efficent, principled regular expression library"
HOMEPAGE="http://code.google.com/p/re2/"
SRC_URI="http://re2.googlecode.com/files/${PN}-${PV##*_p}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

# TODO: the directory in the tarball should really be versioned.
S="${WORKDIR}/${PN}"

src_prepare() {
	# Fix problems with FilteredRE2 symbols not being exported.
	epatch "${FILESDIR}/${PN}-symbols-r0.patch"
}

src_compile() {
	makeopts=(
		AR="$(tc-getAR)"
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS} -pthread"
		LDFLAGS="${LDFLAGS} -pthread"
		NM="$(tc-getNM)"
	)
	emake "${makeopts[@]}"
}

src_test() {
	emake "${makeopts[@]}" shared-test
}

src_install() {
	emake DESTDIR="${ED}" prefix=usr libdir=usr/$(get_libdir) install
	# TODO: the upstream should not build static library at all.
	rm "${ED}/usr/$(get_libdir)/libre2.a" || die
	dodoc AUTHORS CONTRIBUTORS README doc/syntax.txt
	dohtml doc/syntax.html
}
