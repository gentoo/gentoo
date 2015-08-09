# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit eutils distutils-r1 perl-module toolchain-funcs

DESCRIPTION="Network Kanji code conversion Filter with UTF-8/16 support"
HOMEPAGE="http://sourceforge.jp/projects/nkf/"
SRC_URI="mirror://sourceforge.jp/nkf/59912/${P}.tar.gz
	linguas_ja? ( http://dev.gentoo.org/~naota/files/nkf.1j )
	python? ( http://dev.gentoo.org/~naota/files/NKF_python20090602.tgz )"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-macos"
IUSE="perl python linguas_ja"

src_prepare() {
	sed -i \
		-e '/^CFLAGS/{s|-g -O2||;s|=|+=|;}' \
		-e '/-o nkf/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		Makefile || die

	if use linguas_ja; then
		cp "${DISTDIR}"/nkf.1j "${S}" || die
	fi

	if use python; then
		mv "${WORKDIR}/NKF.python" "${S}" || die
		epatch "${FILESDIR}"/${P}-strip.patch
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" nkf || die
	if use perl; then
		cd "${S}/NKF.mod"
		perl-module_src_compile
	fi
	if use python; then
		cd "${S}/NKF.python"
		distutils-r1_src_compile
	fi
}

src_test() {
	emake test || die
	if use perl; then
		cd "${S}/NKF.mod"
		perl-module_src_test
	fi
}

src_install() {
	dobin nkf || die
	doman nkf.1

	if use linguas_ja; then
		./nkf -e nkf.1j > nkf.1
		doman -i18n=ja nkf.1
	fi
	dodoc nkf.doc

	if use perl; then
		cd "${S}/NKF.mod"
		perl-module_src_install
	fi
	if use python; then
		cd "${S}/NKF.python"
		distutils-r1_src_install
	fi
}
