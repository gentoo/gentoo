# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit linux-info eutils toolchain-funcs

DESCRIPTION="IP over DNS tunnel"
HOMEPAGE="http://code.kryo.se/iodine/"
SRC_URI="http://code.kryo.se/${PN}/${P}.tar.gz"

CONFIG_CHECK="~TUN"

LICENSE="ISC GPL-2" #GPL-2 for init script bug #426060
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

src_prepare(){
	epatch "${FILESDIR}"/${P}-TestMessage.patch
	epatch "${FILESDIR}"/${P}-new-systemd.patch

	sed -e '/^\s@echo \(CC\|LD\)/d' \
		-e 's:^\(\s\)@:\1:' \
		-i {,src/}Makefile || die

	tc-export CC
}

src_compile() {
	#shipped ./Makefiles doesn't pass -j<n> to submake
	emake -C src TARGETOS=Linux all
}

src_install() {
	#don't re-run submake
	sed -e '/^install:/s: all: :' \
		-i Makefile || die
	emake prefix="${EPREFIX}"usr DESTDIR="${D}" install

	dodoc CHANGELOG README TODO

	newinitd "${FILESDIR}"/iodined-1.init iodined
	newconfd "${FILESDIR}"/iodined.conf iodined
	keepdir /var/empty
	fperms 600 /etc/conf.d/iodined
}
