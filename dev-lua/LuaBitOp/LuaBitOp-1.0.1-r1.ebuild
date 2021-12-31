# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
inherit eutils multilib toolchain-funcs

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-lang/lua-5.1*"
RDEPEND="${DEPEND}"

src_prepare()
{
	sed -i \
		-e '/^CFLAGS.*=/s/=/ +=/' \
		-e '/^CFLAGS/s/-O2 -fomit-frame-pointer //' \
		Makefile || die "sed failed"
	epatch "${FILESDIR}/${PN}-ldflags.patch"
}

src_compile()
{
	emake CC="$(tc-getCC)"
}

src_test()
{
	make test
}

src_install()
{
	exeinto /usr/$(get_libdir)/lua/5.1
doexe bit.so
	dohtml -r doc/*
}
