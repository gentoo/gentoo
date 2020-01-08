# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Counting pipe, measures data transfered over pipe"
HOMEPAGE="https://github.com/HaraldKi/cpipe"
SRC_URI="https://github.com/HaraldKi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare()	{
	default

	sed -i \
		-e "s/CFLAGS =/CFLAGS =${CFLAGS} /" \
		-e "s/-lm/-lm ${LDFLAGS}/" \
		-e "s/744/644/" makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install()	{
	dobin "${PN}"
	doman "${PN}.1"
}
