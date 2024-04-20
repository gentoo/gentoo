# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="Collection of blackletter fonts for LaTeX"
HOMEPAGE="https://www.gaehrken.de/fraktur/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}-base.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-tfrak.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-obibel.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-odedruck.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-odeschmk.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-oweissfr.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-oweissgo.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-talteswab.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-tbrtkpf.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-tkngsbg.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-twieynk.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-twieyvig.zip
	https://dev.gentoo.org/~ulm/distfiles/${P}-tzentenar.zip"
S="${WORKDIR}"

LICENSE="LPPL-1.2 free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

TEXMF="/usr/share/texmf-site"

src_prepare() {
	default
	# remove spurious files, so that doins -r is possible later
	find . -type f -name '.*' | xargs rm -f || die
}

src_install() {
	insinto "${TEXMF}"/tex/latex
	doins -r tex/latex/fraktur
	insinto "${TEXMF}"/fonts
	doins -r fonts/{tfm,vf,type1,enc}
	insinto "${TEXMF}"/fonts/map/dvips/fraktur
	doins fonts/map/dvips/*.map

	local m
	for m in fobi fodd fods fowf fowg ftas ftbk ftkb ftwv ftwy ftzf; do
		echo "Map ${m}.map" >>"${T}"/50frakturx.cfg
	done
	insinto /etc/texmf/updmap.d
	doins "${T}"/50frakturx.cfg

	dodoc -r doc/fonts/fraktur/*

	# symlink for texdoc
	dosym -r /usr/share/doc/${PF} "${TEXMF}"/doc/fonts/fraktur
}
