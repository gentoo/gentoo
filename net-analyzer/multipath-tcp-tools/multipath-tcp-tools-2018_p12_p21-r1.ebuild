# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Analysis tools for Multipath Transmission Control Protocol (MPTCP)"
HOMEPAGE="https://github.com/nasa/multipath-tcp-tools"
SRC_URI="https://github.com/nasa/multipath-tcp-tools/archive/v${PV//_p/-}.tar.gz -> ${P}.tar.gz"

LICENSE="NOSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/openssl:=
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
S=${WORKDIR}/${P//_p/-}/network-traffic-analysis-tools

src_prepare() {
	sed -i \
		-e 's|/man/man1|/share&|g' \
		-e 's|$(LDLIBS)|$(LDFLAGS) &|g' \
		Makefile || die

	default
}

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake PREFIX="${D}/${EPREFIX}/usr" install

	dodoc README
}
