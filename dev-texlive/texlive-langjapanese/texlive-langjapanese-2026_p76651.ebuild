# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langjapanese.r76651
	ascmac.r79461
	asternote.r63838
	babel-japanese.r57733
	bxbase.r78793
	bxcjkjatype.r78793
	bxcoloremoji.r79465
	bxghost.r78793
	bxjaholiday.r78793
	bxjalipsum.r79277
	bxjaprnind.r78793
	bxjatoucs.r78793
	bxjscls.r79198
	bxorigcapt.r78793
	bxwareki.r79312
	chuushaku.r73263
	convbkmk.r49252
	convert-jpfonts.r73551
	endnotesj.r77682
	gckanbun.r79444
	gentombow.r77682
	haranoaji.r76078
	haranoaji-extra.r76079
	ieejtran.r76790
	ifptex.r77682
	ifxptex.r46153
	ipaex.r61719
	japanese-mathformulas.r64678
	japanese-otf.r79618
	jieeetran.r76924
	jlreq.r79733
	jlreq-deluxe.r78373
	jpneduenumerate.r72898
	jpnedumathsymbols.r72959
	jsclasses.r77682
	kanbun.r77682
	luatexja.r79037
	luwa-ul.r77595
	mendex-doc.r77843
	morisawa.r77682
	outoruby.r74638
	pbibtex-base.r66085
	platex.r77830
	platex-tools.r72097
	plautopatch.r77682
	ptex.r77830
	ptex-base.r64072
	ptex-fontmaps.r65953
	ptex-fonts.r64330
	ptex2pdf.r65953
	pxbase.r77682
	pxchfon.r79479
	pxcjkcat.r77682
	pxjahyper.r79106
	pxjodel.r77682
	pxrubrica.r79461
	pxufont.r77682
	uplatex.r77830
	uptex.r77830
	uptex-base.r77840
	uptex-fonts.r74119
	wadalab.r42428
	zxjafbfont.r77682
	zxjatype.r77682
"
TEXLIVE_MODULE_SRC_CONTENTS="
	ascmac.doc.r79461
	asternote.doc.r63838
	babel-japanese.doc.r57733
	bxbase.doc.r78793
	bxcjkjatype.doc.r78793
	bxcoloremoji.doc.r79465
	bxghost.doc.r78793
	bxjaholiday.doc.r78793
	bxjalipsum.doc.r79277
	bxjaprnind.doc.r78793
	bxjatoucs.doc.r78793
	bxjscls.doc.r79198
	bxorigcapt.doc.r78793
	bxwareki.doc.r79312
	chuushaku.doc.r73263
	convbkmk.doc.r49252
	convert-jpfonts.doc.r73551
	endnotesj.doc.r77682
	gckanbun.doc.r79444
	gentombow.doc.r77682
	haranoaji.doc.r76078
	haranoaji-extra.doc.r76079
	ieejtran.doc.r76790
	ifptex.doc.r77682
	ifxptex.doc.r46153
	ipaex.doc.r61719
	japanese-mathformulas.doc.r64678
	japanese-otf.doc.r79618
	jieeetran.doc.r76924
	jlreq.doc.r79733
	jlreq-deluxe.doc.r78373
	jpneduenumerate.doc.r72898
	jpnedumathsymbols.doc.r72959
	jsclasses.doc.r77682
	kanbun.doc.r77682
	lshort-japanese.doc.r79461
	luatexja.doc.r79037
	luwa-ul.doc.r77595
	mendex-doc.doc.r77843
	morisawa.doc.r77682
	outoruby.doc.r74638
	pbibtex-base.doc.r66085
	pbibtex-manual.doc.r66181
	platex.doc.r77830
	platex-tools.doc.r72097
	platexcheat.doc.r49557
	plautopatch.doc.r77682
	ptex.doc.r77830
	ptex-base.doc.r64072
	ptex-fontmaps.doc.r65953
	ptex-fonts.doc.r64330
	ptex-manual.doc.r75173
	ptex2pdf.doc.r65953
	pxbase.doc.r77682
	pxchfon.doc.r79479
	pxcjkcat.doc.r77682
	pxjahyper.doc.r79106
	pxjodel.doc.r77682
	pxrubrica.doc.r79461
	pxufont.doc.r77682
	texlive-ja.doc.r78540
	uplatex.doc.r77830
	uptex.doc.r77830
	uptex-base.doc.r77840
	uptex-fonts.doc.r74119
	wadalab.doc.r42428
	zxjafbfont.doc.r77682
	zxjatype.doc.r77682
"
TEXLIVE_MODULE_DOC_CONTENTS="
	ascmac.source.r79461
	babel-japanese.source.r57733
	bxjscls.source.r79198
	japanese-otf.source.r79618
	jlreq.source.r79733
	jsclasses.source.r77682
	luatexja.source.r79037
	mendex-doc.source.r77843
	morisawa.source.r77682
	outoruby.source.r74638
	platex.source.r77830
	ptex-fontmaps.source.r65953
	pxrubrica.source.r79461
	uplatex.source.r77830
"

inherit texlive-module

DESCRIPTION="TeXLive Japanese"

LICENSE="BSD BSD-2 GPL-2 GPL-2+ GPL-3 LPPL-1.3 LPPL-1.3c MIT OFL-1.1 TeX TeX-other-free public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-langcjk-2026
"
RDEPEND="
	${COMMON_DEPEND}
	dev-lang/ruby
"
DEPEND="
	${COMMON_DEPEND}
	>=dev-texlive/texlive-latex-2026
"

TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/convbkmk/convbkmk.rb
	texmf-dist/scripts/ptex-fontmaps/kanji-config-updmap-sys.sh
	texmf-dist/scripts/ptex-fontmaps/kanji-config-updmap-user.sh
	texmf-dist/scripts/ptex-fontmaps/kanji-config-updmap.pl
	texmf-dist/scripts/ptex-fontmaps/kanji-fontmap-creator.pl
	texmf-dist/scripts/ptex2pdf/ptex2pdf.lua
"

src_prepare() {
	default

	# e(u)ptex are installed by texlive-core[cjk]
	sed -i '/AddFormat name=eptex /d' tlpkg/tlpobj/ptex.tlpobj || die
	sed -i '/AddFormat name=euptex /d' tlpkg/tlpobj/uptex.tlpobj || die

	if use doc; then
		# ptekf.1 is installed by dev-libs/ptexenc
		rm texmf-dist/doc/man/man1/ptekf.1 || die
	fi
}
