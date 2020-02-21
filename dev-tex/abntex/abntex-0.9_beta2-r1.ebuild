# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="LaTeX macros for writing documents following the ABNT norms"
HOMEPAGE="https://www.abntex.net.br/"
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
