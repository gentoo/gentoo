# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Determines where a given nameserver gets its information from"
HOMEPAGE="https://www.mavetju.org/unix/general.php"
SRC_URI="https://www.mavetju.org/download/${P}.tar.bz2 -> ${P}.tar.gz"
LICENSE="BSD-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux"

BDEPEND="
	dev-lang/perl
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.9-argv0.patch
)
S=${WORKDIR}/${PN}

src_compile() {
	emake CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.8

	dodoc CHANGES CONTACT README
}
