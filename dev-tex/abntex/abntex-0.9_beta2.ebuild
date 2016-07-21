# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit latex-package

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="LaTeX macros for writing documents following the ABNT norms"
HOMEPAGE="http://abntex.codigolivre.org.br/ http://abntex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${PN}-doc-${MY_PV}.tar.gz )"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc examples lyx"

DEPEND="dev-texlive/texlive-latex
	dev-texlive/texlive-latexrecommended
	lyx? ( app-office/lyx )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P%-*}"

src_prepare() {
	# fix permissions
	find . -type f -exec chmod 0644 "{}" + || die 'chmod 0644 failed.'
	find . -type d -exec chmod 0755 "{}" + || die 'chmod 0755 failed.'
}

src_install() {
	dobin bin/geratss || die 'dobin failed.'

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r texmf/doc/* || die 'could not install examples.'
	fi

	rm -rf texmf/doc

	insinto /usr/share/texmf-site
	doins -r texmf/* || die 'could not install texmf.'

	if use lyx; then
		insinto /usr/share/lyx
		doins -r lyx/* || die 'could not install lyx files.'
	fi

	dodoc LEIAME || die 'could not install LEIAME'

	if use doc; then
		insinto /usr/share/doc/${PF}/docs
		doins -r compiled.docs/* || die "could not install doc"
	fi
}
