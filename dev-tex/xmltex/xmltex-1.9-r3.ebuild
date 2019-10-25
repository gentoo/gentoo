# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package texlive-common

DESCRIPTION="A non validating namespace aware XML parser implemented in TeX"
HOMEPAGE="http://www.dcarlisle.demon.co.uk/xmltex/manual.html"
# Taken from: ftp://www.ctan.org/tex-archive/macros/xmltex.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"

S=${WORKDIR}/${PN}/base

TEXMF=/usr/share/texmf-site

DEPEND="virtual/latex-base"

RDEPEND="${DEPEND}"

src_compile() {
	fmt_call="$(has_version '>=app-text/texlive-core-2019' \
	  && echo "fmtutil-user" || echo "fmtutil")"

	TEXMFHOME="${S}" $fmt_call --cnffile "${FILESDIR}/format.${PN}.cnf" --fmtdir "${S}/texmf-var/web2c" --all\
			|| die "failed to build format ${PN}"
}

src_install() {
	insinto /var/lib/texmf
	doins -r texmf-var

	insinto ${TEXMF}/tex/xmltex/base
	doins *.{xmt,cfg,xml,tex}
	insinto ${TEXMF}/tex/xmltex/config
	doins *.ini

	etexlinks "${FILESDIR}/format.${PN}.cnf"
	insinto /etc/texmf/fmtutil.d
	doins "${FILESDIR}/format.${PN}.cnf"

	dodoc *.html
	dodoc readme.txt
}
