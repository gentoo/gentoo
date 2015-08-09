# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib multilib-minimal toolchain-funcs

DESCRIPTION="An efficent, principled regular expression library"
HOMEPAGE="http://code.google.com/p/re2/"
SRC_URI="http://re2.googlecode.com/files/${PN}-${PV##*_p}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# TODO: the directory in the tarball should really be versioned.
S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-compile-r0.patch"
	multilib_copy_sources
}

mymake() {
	local makeopts=(
		AR="$(tc-getAR)"
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS} -pthread"
		LDFLAGS="${LDFLAGS} -pthread"
		NM="$(tc-getNM)"
	)
	emake "${makeopts[@]}" "$@"
}

multilib_src_compile() {
	mymake
}

multilib_src_test() {
	mymake static-test
}

multilib_src_install() {
	emake DESTDIR="${ED}" prefix=usr libdir=usr/$(get_libdir) install
}

multilib_src_install_all() {
	dodoc AUTHORS CONTRIBUTORS README doc/syntax.txt
	dohtml doc/syntax.html
}
