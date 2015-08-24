# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic eutils multilib multilib-minimal toolchain-funcs

DESCRIPTION="An efficent, principled regular expression library"
HOMEPAGE="https://code.google.com/p/re2/"
SRC_URI="https://re2.googlecode.com/files/${PN}-${PV##*_p}.tgz"

LICENSE="BSD"
# Symbols removed in version 20140110
# http://upstream-tracker.org/compat_reports/re2/20131024_to_20140110/abi_compat_report.html
# https://code.google.com/p/re2/issues/detail?id=111
SLOT="0/0.20140110"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

# TODO: the directory in the tarball should really be versioned.
S="${WORKDIR}/${PN}"

src_prepare() {
	multilib_copy_sources
}

src_configure() {
	tc-export AR CXX NM
	append-cxxflags -pthread
	append-ldflags -pthread
}

multilib_src_test() {
	emake static-test
}

multilib_src_install() {
	emake DESTDIR="${ED}" prefix=usr libdir=usr/$(get_libdir) install
}

multilib_src_install_all() {
	dodoc AUTHORS CONTRIBUTORS README doc/syntax.txt
	dohtml doc/syntax.html
}
