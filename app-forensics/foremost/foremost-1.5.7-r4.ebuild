# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs prefix

DESCRIPTION="Console program to recover files based on their headers and footers"
HOMEPAGE="http://foremost.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
# starting to hate sf.net ...
SRC_URI="http://foremost.sourceforge.net/pkg/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~arm64-macos ~x64-macos"

src_prepare() {
	PATCHES=(
		"${FILESDIR}/${PN}-1.4-config-location.patch"
		"${FILESDIR}/${PN}-1.5.7-format-security.patch" # bug 521038
		"${FILESDIR}/${PN}-1.5.7-set-but-unused.patch" # bug 706886
		"${FILESDIR}/${PN}-1.5.7-fno-common.patch" # bug 722196
		"${FILESDIR}/${PN}-1.5.7-musl.patch" # bug 830473
	)

	default
	hprefixify config.c
}

src_compile() {
	# see also bug 906187

	emake \
		RAW_FLAGS="${CFLAGS} -Wall ${LDFLAGS} -D_LARGEFILE64_SOURCE" \
		RAW_CC="$(tc-getCC) -DVERSION=\\\"${PV}\\\"" \
		CONF=/etc
}

src_install() {
	dobin foremost
	gunzip foremost.8.gz || die
	doman foremost.8
	insinto /etc
	doins foremost.conf
	dodoc README CHANGES
}
