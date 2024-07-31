# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Open source command-line RTMP client to stream audio or video flash content"
HOMEPAGE="https://savannah.nongnu.org/projects/flvstreamer/"
SRC_URI="mirror://nongnu/${PN}/source/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

src_prepare() {
	default
	#fix Makefile ( bug #298535 and bug #318353)
	sed -i 's/\$(MAKEFLAGS)//g' Makefile || die "failed to fix Makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS} `sed -n 's/DEF=\(.*\)/\1/p' Makefile`" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" linux
}

src_install() {
	dobin {${PN},streams}
	dodoc README ChangeLog
}
