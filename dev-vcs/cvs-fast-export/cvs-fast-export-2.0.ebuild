# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="fast-export history from a CVS repository or RCS collection"
HOMEPAGE="http://www.catb.org/~esr/cvs-fast-export/"
SRC_URI="
	http://www.catb.org/~esr/${PN}/${P}.tar.gz
	https://distfiles.gentoo.org/pub/dev/mattst88@gentoo.org/${P}-deps.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

BDEPEND="dev-ruby/asciidoctor"

src_compile() {
	# '.adoc.html' rules can't be executed in parallel
	# as they reuse the same 'docbook-xsl.css' file name.
	emake -j1 html
	emake man
	ego build -ldflags "-X main.version=${PV}" -o ${PN} .
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc {NEWS,README,TODO,hacking,reporting-bugs}.adoc
}
