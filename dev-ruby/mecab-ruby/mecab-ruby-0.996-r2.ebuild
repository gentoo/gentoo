# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit ruby-ng

DESCRIPTION="Ruby binding for MeCab"
HOMEPAGE="https://taku910.github.io/mecab/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN%-*}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
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
