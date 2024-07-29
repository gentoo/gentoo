# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A tool to parse Squid access log file and to generate reports"
HOMEPAGE="http://www.stefanopassiglia.com/misc.htm"
SRC_URI="http://www.stefanopassiglia.com/downloads/${P}.tar.gz"
S="${WORKDIR}/src"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-format-security.patch
)

src_prepare() {
	default

	# Respect CFLAGS
	sed -i Makefile \
		-e '/^CCFLAGS=/s|-g| $(CFLAGS) $(LDFLAGS)|' \
		|| die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	cd "${WORKDIR}" || die
	dobin src/squidsites
	dodoc Authors Bugs ChangeLog GNU-Manifesto.html README
}
