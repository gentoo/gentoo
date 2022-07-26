# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 flag-o-matic toolchain-funcs

DESCRIPTION="Analysis tools for Multipath Transmission Control Protocol (MPTCP)"
HOMEPAGE="https://github.com/nasa/multipath-tcp-tools"
EGIT_REPO_URI="https://github.com/nasa/multipath-tcp-tools/"

LICENSE="NOSA"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-libs/openssl:=
	net-libs/libpcap
"
RDEPEND="
	${DEPEND}
"
S=${WORKDIR}/${P}/network-traffic-analysis-tools

src_prepare() {
	sed -i \
		-e 's|/man/man1|/share&|g' \
		-e 's|$(LDLIBS)|$(LDFLAGS) &|g' \
		Makefile || die

	default
}

src_compile() {
	# bug #861179
	append-flags -fno-strict-aliasing

	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake PREFIX="${D}/${EPREFIX}/usr" install

	dodoc README
}
