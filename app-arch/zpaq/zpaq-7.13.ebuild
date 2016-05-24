# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

MY_P=${PN}${PV/./}
DESCRIPTION="Journaling incremental deduplicating archiving compressor"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="~app-arch/libzpaq-${PV}"
# perl for pod2man
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-lang/perl"

S=${WORKDIR}

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" zpaq.o zpaq.1
	# link manually to use shared library
	emake -f /dev/null CC="$(tc-getCXX)" LDLIBS="-lzpaq -pthread" zpaq
}

src_test() {
	# no idea why the 'test' needs that
	touch libzpaq.so libzpaq.so.1 || die
	default
}

src_install() {
	dobin zpaq
	doman zpaq.1
}

pkg_postinst() {
	if ! has_version app-arch/zpaq-extras; then
		elog "You may also want to install app-arch/zpaq-extras package which provides"
		elog "few additional configs and preprocessors for use with zpaq."
	fi
}
