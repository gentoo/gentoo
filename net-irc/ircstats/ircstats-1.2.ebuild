# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="IRCStats-${PV}"

DESCRIPTION="IRCStats is a Linux log analyzer"
HOMEPAGE="https://humdi.net/ircstats/"
SRC_URI="https://humdi.net/ircstats/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ircstats
	insinto /usr/share/ircstats
	doins -r html languages colors
	dodoc CHANGES README TODO ircstats.cfg
}

pkg_postinst() {
	elog "The IRCStats files have been installed in ${EROOT}/usr/share/ircstats"
	elog "You can find an example ircstats.cfg in ${EROOT}/usr/share/doc/${PF}"
}
