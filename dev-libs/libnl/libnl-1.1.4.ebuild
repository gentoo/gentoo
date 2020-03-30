# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="Libraries providing APIs to netlink protocol based Linux kernel interfaces"
HOMEPAGE="http://www.infradead.org/~tgr/libnl/"
SRC_URI="http://www.infradead.org/~tgr/libnl/files/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
DOCS=( ChangeLog )

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.1-vlan-header.patch \
		"${FILESDIR}"/${PN}-1.1-flags.patch \
		"${FILESDIR}"/${PN}-1.1.3-offsetof.patch
	sed -i \
		-e '/@echo/d' \
		Makefile.rules {lib,src,tests}/Makefile || die
	sed -i \
		-e 's|-g ||g' \
		Makefile.opts.in || die

	if ! use static-libs; then
		sed -i lib/Makefile -e '/OUT_AR/d' || die
	fi

	rm -f lib/libnl.a
}

src_compile() {
	emake AR=$(tc-getAR)

	if use doc ; then
		cd "${S}/doc"
		emake gendoc
	fi
}

src_install() {
	default

	if use doc ; then
		cd "${S}/doc"
		dohtml -r html/*
	fi
}
