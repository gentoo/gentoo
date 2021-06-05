# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="aalok akshar amsldoc-vn aramaic-serto babel-azerbaijani babel-esperanto babel-georgian babel-hebrew babel-indonesian babel-interlingua babel-malay babel-sorbian babel-thai babel-vietnamese bangtex bengali burmese chhaya cjhebrew ctib ebong ethiop ethiop-t1 fc fonts-tlwg hindawi-latex-template hyphen-afrikaans hyphen-armenian hyphen-coptic hyphen-esperanto hyphen-ethiopic hyphen-georgian hyphen-indic hyphen-indonesian hyphen-interlingua hyphen-sanskrit hyphen-thai hyphen-turkmen latex-mr latexbangla latino-sine-flexione lshort-thai lshort-vietnamese marathi ntheorem-vn padauk quran-bn quran-ur sanskrit sanskrit-t1 thaienum thaispec unicode-alphabets velthuis vntex wnri wnri-latex xetex-devanagari collection-langother
"
TEXLIVE_MODULE_DOC_CONTENTS="aalok.doc akshar.doc amsldoc-vn.doc aramaic-serto.doc babel-azerbaijani.doc babel-esperanto.doc babel-georgian.doc babel-hebrew.doc babel-indonesian.doc babel-interlingua.doc babel-malay.doc babel-sorbian.doc babel-thai.doc babel-vietnamese.doc bangtex.doc bengali.doc burmese.doc chhaya.doc cjhebrew.doc ctib.doc ebong.doc ethiop.doc ethiop-t1.doc fc.doc fonts-tlwg.doc hindawi-latex-template.doc hyphen-sanskrit.doc latex-mr.doc latexbangla.doc latino-sine-flexione.doc lshort-thai.doc lshort-vietnamese.doc marathi.doc ntheorem-vn.doc padauk.doc quran-bn.doc quran-ur.doc sanskrit.doc sanskrit-t1.doc thaienum.doc thaispec.doc unicode-alphabets.doc velthuis.doc vntex.doc wnri.doc wnri-latex.doc xetex-devanagari.doc "
TEXLIVE_MODULE_SRC_CONTENTS="aalok.source akshar.source babel-azerbaijani.source babel-esperanto.source babel-hebrew.source babel-indonesian.source babel-interlingua.source babel-malay.source babel-sorbian.source babel-thai.source babel-vietnamese.source bengali.source burmese.source chhaya.source ctib.source ethiop.source fonts-tlwg.source hyphen-armenian.source hyphen-ethiopic.source hyphen-turkmen.source marathi.source sanskrit.source thaispec.source vntex.source wnri-latex.source "
inherit  texlive-module
DESCRIPTION="TeXLive Other languages"

LICENSE=" CC-BY-SA-4.0 GPL-1 GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2021"

RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/ebong/ebong.py"
