# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="regexp_parser.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library for tokenizing, lexing, and parsing Ruby regular expressions"
HOMEPAGE="https://github.com/ammar/regexp_parser"
SRC_URI="https://github.com/ammar/regexp_parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc"
IUSE=""

DEPEND+=" =dev-util/ragel-6*"

ruby_add_bdepend "dev-ruby/rake dev-ruby/rspec:3
	test? ( dev-ruby/leto:2 dev-ruby/regexp_property_values dev-ruby/rspec:3 )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_compile() {
	CI=true ${RUBY} -S rake ragel:rb || die
}
