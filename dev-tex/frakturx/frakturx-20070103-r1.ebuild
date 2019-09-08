# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Collection of blackletter fonts for LaTeX"
HOMEPAGE="http://www.gaehrken.de/fraktur/"
SRC_URI="mirror://gentoo/${P}-base.zip
	mirror://gentoo/${P}-tfrak.zip
	mirror://gentoo/${P}-obibel.zip
	mirror://gentoo/${P}-odedruck.zip
	mirror://gentoo/${P}-odeschmk.zip
	mirror://gentoo/${P}-oweissfr.zip
	mirror://gentoo/${P}-oweissgo.zip
	mirror://gentoo/${P}-talteswab.zip
	mirror://gentoo/${P}-tbrtkpf.zip
	mirror://gentoo/${P}-tkngsbg.zip
	mirror://gentoo/${P}-twieynk.zip
	mirror://gentoo/${P}-twieyvig.zip
	mirror://gentoo/${P}-tzentenar.zip"

LICENSE="LPPL-1.2 free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	default
	# remove spurious files, so that doins -r is possible later
	find . -type f -name '.*' | xargs rm -f || die
}

src_install() {
	insinto ${TEXMF}/tex/latex
	doins -r tex/latex/fraktur
	insinto ${TEXMF}/fonts
	doins -r fonts/{tfm,vf,type1,enc}
	insinto ${TEXMF}/fonts/map/dvips/fraktur
	doins fonts/map/dvips/*.map

	local m
	for m in fobi fodd fods fowf fowg ftas ftbk ftkb ftwv ftwy ftzf; do
		echo "Map ${m}.map" >>"${T}"/50frakturx.cfg
	done
	insinto /etc/texmf/updmap.d
	doins "${T}"/50frakturx.cfg

	dodoc -r doc/fonts/fraktur/*

	# symlink for texdoc
	dosym ../../../doc/${PF} ${TEXMF}/doc/fonts/fraktur
}
