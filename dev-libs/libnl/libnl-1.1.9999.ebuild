# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 multilib toolchain-funcs

DESCRIPTION="Libraries providing APIs to netlink protocol based Linux kernel interfaces"
HOMEPAGE="https://www.infradead.org/~tgr/libnl/"
EGIT_REPO_URI="https://github.com/tgraf/libnl-1.1-stable"
LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS=""
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
DOCS=( ChangeLog )
PATCHES=(
	"${FILESDIR}"/${PN}-1.1-vlan-header.patch
	"${FILESDIR}"/${PN}-1.1-flags.patch
	"${FILESDIR}"/${PN}-1.1.3-offsetof.patch
)

src_prepare() {
	default

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
		docinto html
		dodoc -r html/*
	fi
}
