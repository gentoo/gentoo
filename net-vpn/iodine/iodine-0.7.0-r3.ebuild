# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="IP over DNS tunnel"
HOMEPAGE="https://code.kryo.se/iodine/"
SRC_URI="https://code.kryo.se/${PN}/${P}.tar.gz"

CONFIG_CHECK="~TUN"

LICENSE="ISC GPL-2" #GPL-2 for init script bug #426060
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

PATCHES=(
	"${FILESDIR}"/${P}-TestMessage.patch
	"${FILESDIR}"/${P}-new-systemd.patch
)

src_prepare() {
	default

	sed -e '/^\s@echo \(CC\|LD\)/d' \
		-e 's:^\(\s\)@:\1:' \
		-i {,src/}Makefile || die

	tc-export CC
}

src_install() {
	# Don't re-run submake
	sed -e '/^install:/s: all: :' \
		-i Makefile || die
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install
	einstalldocs

	newinitd "${FILESDIR}"/iodined-1.init iodined
	newconfd "${FILESDIR}"/iodined.conf iodined
	keepdir /var/empty
	fperms 600 /etc/conf.d/iodined
}
