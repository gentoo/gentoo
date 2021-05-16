# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

USE_RUBY="ruby25 ruby26 ruby27"

inherit ruby-ng

DESCRIPTION="Ruby binding for MeCab"
HOMEPAGE="http://taku910.github.io/mecab/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN%-*}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="~app-text/mecab-${PV}"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README test.rb )
HTML_DOCS=( bindings.html )

each_ruby_configure() {
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	emake V=1
}

each_ruby_install() {
	emake DESTDIR="${D}" install
}

all_ruby_install() {
	einstalldocs
}
