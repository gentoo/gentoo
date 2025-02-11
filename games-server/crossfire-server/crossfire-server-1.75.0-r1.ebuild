# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-server/}"
DESCRIPTION="Server for the crossfire clients"
HOMEPAGE="https://crossfire.real-time.com/"
SRC_URI="https://downloads.sourceforge.net/crossfire/crossfire-server/${PV}/crossfire-${PV}.tar.gz
	https://downloads.sourceforge.net/crossfire/crossfire-maps/${PV}/crossfire-maps-${PV}.tar.gz"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"
RESTRICT="test"

RDEPEND="
	net-misc/curl
	sys-libs/zlib
	virtual/libcrypt:=
	X? (
		x11-libs/libXaw
		media-libs/libpng:0=
	)
"

PATCHES=( "${FILESDIR}/${P}-incompatible-func-pointers.patch" )

src_prepare() {
	default

	# bug #236205
	rm -f "${WORKDIR}"/maps/Info/combine.pl || die
#	ln -s "${WORKDIR}"/arch "${S}"/lib || die

	eapply "${FILESDIR}"/${P}-format.patch
}

src_compile() {
	# work around the collect.pl locking
	emake -j1 -C lib
	emake
}

src_install() {
	default

	keepdir /var/lib/crossfire/{account,datafiles,maps,players,template-maps,unique-items}

	insinto /usr/share/crossfire
	doins -r "${WORKDIR}"/maps

	find "${ED}" -name '*.la' -delete || die
}
