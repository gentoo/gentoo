# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit latex-package

DESCRIPTION="Collection of blackletter fonts for LaTeX"
HOMEPAGE="https://www.gaehrken.de/fraktur/"
SRC_URI="https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-base.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-tfrak.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-obibel.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-odedruck.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-odeschmk.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-oweissfr.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-oweissgo.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-talteswab.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-tbrtkpf.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-tkngsbg.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-twieynk.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-twieyvig.zip
	https://distfiles.gentoo.org/pub/dev/ulm@gentoo.org/${P}-tzentenar.zip"
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
