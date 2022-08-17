# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYSPELL_DICT=(
	"tr_TR.aff"
	"tr_TR.dic"
)

inherit myspell-r2

DESCRIPTION="Turkish dictionaries for myspell/hunspell"
HOMEPAGE="https://extensions.libreoffice.org/en/extensions/show/turkish-spellcheck-dictionary"
SRC_URI="https://extensions.libreoffice.org/assets/downloads/z/oo-turkish-dict-v1-2.oxt"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"

src_prepare() {
	default
	mv tr-TR.aff tr_TR.aff || die
	mv tr-TR.dic tr_TR.dic || die
}
