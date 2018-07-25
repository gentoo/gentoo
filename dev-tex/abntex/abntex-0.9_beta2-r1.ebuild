# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	default
}

src_install() {
	dobin bin/geratss

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r texmf/doc/*
	fi

	rm -rf texmf/doc || die

	insinto /usr/share/texmf-site
	doins -r texmf/*

	if use lyx; then
		insinto /usr/share/lyx
		doins -r lyx/*
	fi

	dodoc LEIAME

	if use doc; then
		insinto /usr/share/doc/${PF}/docs
		doins -r compiled.docs/*
	fi
}
