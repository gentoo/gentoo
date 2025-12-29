# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Console-based network monitoring utility"
HOMEPAGE="https://github.com/iptraf-ng/iptraf-ng"
SRC_URI="https://github.com/iptraf-ng/iptraf-ng/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 doc? ( FDL-1.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	>=sys-libs/ncurses-5.7-r7:=
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.2-buffer_overflow.patch"
)

src_prepare() {
	sed -i \
		-e '/^CC =/d' \
		-e '/^CFLAGS/s:= -g -O2:+= :' \
		-e '/^LDFLAGS =/d' \
		-e 's|$(QUIET_[[:alpha:]]*)||g' \
		Makefile || die
	sed -i \
		-e 's|IPTRAF|&-NG|g' \
		-e 's|IPTraf|&-NG|g' \
		-e 's|iptraf|&-ng|g' \
		src/*.8 || die

	default
}

src_configure() {
	# The configure script does not do very much we do not already control
	append-cppflags '-DLOCKDIR=\"/run/lock/iptraf-ng\"'
	tc-export CC
}

src_install() {
	dosbin ${PN}

	doman src/*.8
	dodoc AUTHORS CHANGES* FAQ README*

	# bug #376157
	keepdir /var/{lib,log}/iptraf-ng

	if use doc; then
		docinto html
		dodoc -r Documentation/*
	fi
}
