# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A meta-package for installing all EMBASSY packages (EMBOSS add-ons)"
HOMEPAGE="http://emboss.sourceforge.net/embassy/"

LICENSE+=" freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"

RDEPEND+="
	>=sci-biology/embassy-cbstools-1.0.0.650
	>=sci-biology/embassy-clustalomega-1.1.0
	>=sci-biology/embassy-domainatrix-0.1.650
	>=sci-biology/embassy-domalign-0.1.650
	>=sci-biology/embassy-domsearch-0.1.650
	>=sci-biology/embassy-emnu-1.05.650
	>=sci-biology/embassy-esim4-1.0.0.650
	>=sci-biology/embassy-hmmer-2.3.2.650
	>=sci-biology/embassy-iprscan-4.3.1.650
	>=sci-biology/embassy-meme-4.7.650
	>=sci-biology/embassy-mse-3.0.0.650
	>=sci-biology/embassy-phylipnew-3.69.650
	>=sci-biology/embassy-signature-0.1.650
	>=sci-biology/embassy-structure-0.1.650
	>=sci-biology/embassy-topo-2.0.650
	>=sci-biology/embassy-vienna-1.7.2.650
"
