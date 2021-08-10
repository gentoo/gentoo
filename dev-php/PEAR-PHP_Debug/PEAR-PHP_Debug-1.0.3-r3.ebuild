# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Provides traces, timings, executed queries, watched variables etc."

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( dev-php/PEAR-Text_Highlighter )"
DOCS=( docs/README docs/INSTALL docs/CHANGELOG docs/FAQ docs/TODO docs/CONTACT )
src_install() {
	php-pear-r2_src_install
	docinto html
	dodoc -r css images js
}
