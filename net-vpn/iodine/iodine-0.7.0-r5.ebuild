# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="IP over DNS tunnel"
HOMEPAGE="https://code.kryo.se/iodine/"
SRC_URI="https://code.kryo.se/${PN}/${P}.tar.gz"

CONFIG_CHECK="~TUN"

LICENSE="ISC GPL-2" #GPL-2 for init script bug #426060
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="selinux systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/zlib:=
	selinux? ( sys-libs/libselinux )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/check )
"
RDEPEND+=" selinux? ( sec-policy/selinux-iodine )"

PATCHES=(
	"${FILESDIR}"/${P}-TestMessage.patch
	"${FILESDIR}"/${P}-new-systemd.patch
)

src_prepare() {
	default

	sed -e '/^\s@echo \(CC\|LD\)/d' \
		-e 's:^\(\s\)@:\1:' \
		-i {,src/}Makefile || die

	if ! use selinux ; then
		sed -i -e 's:libselinux:idonotexist&:' src/osflags || die
	fi

	if ! use systemd ; then
		sed -i -e 's:libsystemd:idonotexist&:' src/osflags || die
	fi

	tc-export CC
}

src_install() {
	# Don't re-run submake
	sed -e '/^install:/s: all: :' \
		-i Makefile || die
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install
	einstalldocs

	newinitd "${FILESDIR}"/iodined-1.init-r1 iodined
	newconfd "${FILESDIR}"/iodined.conf-r1 iodined
	keepdir /var/empty
	fperms 600 /etc/conf.d/iodined
}
