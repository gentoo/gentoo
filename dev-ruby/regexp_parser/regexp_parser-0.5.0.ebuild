# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A library for tokenizing, lexing, and parsing Ruby regular expressions"
HOMEPAGE="https://github.com/ammar/regexp_parser"
SRC_URI="https://github.com/ammar/regexp_parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND+=" =dev-util/ragel-6*"

ruby_add_bdepend "dev-ruby/rake"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
	sed -i -e '1irequire "delegate"' test/support/warning_extractor.rb || die
}

each_ruby_compile() {
	${RUBY} -S rake ragel:rb || die
}

each_ruby_test() {
	${RUBY} -Ilib bin/test || die
}
