# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN^}-XXII"

DESCRIPTION="Chess engine suitable for beginner and intermediate players"
HOMEPAGE="http://phalanx.sourceforge.net/"
SRC_URI="mirror://sourceforge/phalanx/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	# configure is not used in the project; confs are in Makefile,
	# and here we override them:
	local define="-DGNUFUN" myvar
	for myvar in "PBOOK" "SBOOK" "LEARN" ; do
		define="${define} -D${myvar}_DIR=\"\\\"${EPREFIX}/usr/share/${PN}\\\"\""
	done
	emake \
		DEFINES="${define}" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin phalanx

	insinto /usr/share/${PN}
	doins pbook.phalanx sbook.phalanx learn.phalanx

	einstalldocs
}
