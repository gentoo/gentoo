# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Very fast anagram generator with dictionary lookup"
HOMEPAGE="https://packages.debian.org/unstable/games/an"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.xz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-libs/icu:=
	sys-apps/miscfiles[-minimal]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
S=${WORKDIR}/${P/_p*}

src_prepare() {
	default

	eapply $(
		for patch in $(cat "${WORKDIR}"/debian/patches/series)
		do
			echo "${WORKDIR}"/debian/patches/$patch
		done
	)

	sed -i \
		-e '/^CC/s|:=|?=|' \
		Makefile || die
	tc-export CC
}

src_install() {
	dobin ${PN}
	newman ${PN}.6 ${PN}.1
	dodoc ALGORITHM
}
