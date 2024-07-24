# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Run cronjobs with overrun protection"
HOMEPAGE="http://www.unixwiz.net/tools/lockrun.html"

SRC_URI="https://downloads.uls.co.za/gentoo/lockrun/lockrun-${PV}.c.gz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"

src_prepare() {
	default
	mv "${P}.c" "${PN}.c" || die
}

src_compile() {
	emake CC="$(tc-getCC)" ${PN}

	# The below tries to extract the first comment block from the source code
	# which represents the official "readme" from the project.  Delete first
	# three lines, then everything from (including) the first comment close at
	# the beginning of a line before removing ' *' from the beginning of the
	# remaining lines.
	sed '1,3 d; /^[[:space:]]*[*]\//,$ d; s/^ \*//' "${PN}.c" > README || die
}

src_install() {
	dobin ${PN}
	einstalldocs
}
