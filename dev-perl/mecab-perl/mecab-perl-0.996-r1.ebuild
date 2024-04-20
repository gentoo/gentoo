# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Perl binding for MeCab"
HOMEPAGE="http://taku910.github.io/mecab/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN%-*}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86"

RDEPEND="~app-text/mecab-${PV}"
BDEPEND="${RDEPEND}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README test.pl )
HTML_DOCS=( bindings.html )

src_install() {
	perl-module_src_install
	einstalldocs
}
