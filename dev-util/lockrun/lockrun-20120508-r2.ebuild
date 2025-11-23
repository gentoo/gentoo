# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Lockrun - runs cronjobs with overrun protection"
HOMEPAGE="http://www.unixwiz.net/tools/lockrun.html"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"

src_unpack() {
	cp -v "${FILESDIR}"/${PN}.c-${PV} "${S}"/${PN}.c || die
	cp -v "${FILESDIR}"/${PN}.c-${PV} "${S}"/README || die
}

src_compile() {
	emake CC="$(tc-getCC)" ${PN}
	sed -i README -e '60q;s|^ \*||g' || die
}

src_install() {
	dobin ${PN}
	einstalldocs
}
