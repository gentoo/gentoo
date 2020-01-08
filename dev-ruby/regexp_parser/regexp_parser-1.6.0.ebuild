# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A library for tokenizing, lexing, and parsing Ruby regular expressions"
HOMEPAGE="https://github.com/ammar/regexp_parser"
SRC_URI="https://github.com/ammar/regexp_parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
IUSE=""

DEPEND+=" =dev-util/ragel-6*"

ruby_add_bdepend "dev-ruby/rake
	test? ( dev-ruby/regexp_property_values dev-ruby/rspec:3 )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_compile() {
	${RUBY} -S rake ragel:rb || die
}

each_ruby_test() {
	${RUBY} -Ilib bin/test || die
}
