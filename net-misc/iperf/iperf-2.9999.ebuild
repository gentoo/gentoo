# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="https://sourceforge.net/projects/iperf2/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://git.code.sf.net/p/iperf2/code"
	inherit git-r3
else
	SRC_URI="https://downloads.sourceforge.net/iperf2/${P}.tar.gz"

	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="HPND"
SLOT="2"
IUSE="debug"
# Fails w/ connection refused to just-spawned daemon
RESTRICT="test"

src_configure() {
	local myeconfargs=(
		$(use_enable debug debuginfo)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	dodoc doc/*
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
