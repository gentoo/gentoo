# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A generic swappable back-end for XML parsing"
HOMEPAGE="https://www.rubydoc.info/gems/multi_xml"
SRC_URI="https://github.com/sferik/multi_xml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc test"

ruby_add_rdepend ">=dev-ruby/bigdecimal-3.1:0"

ruby_add_bdepend "doc? ( dev-ruby/yard )"
ruby_add_bdepend "test? ( dev-ruby/ox )"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/helper.rb || die
	sed -e '/bundler/I s:^:#:' \
		-e '/yardstick/,/end/ s:^:#:' \
		-e '/rubocop/I s:^:#:' \
		-i Rakefile || die
}

each_ruby_test() {
	CI=true each_fakegem_test
}
