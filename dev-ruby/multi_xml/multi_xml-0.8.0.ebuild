# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A generic swappable back-end for XML parsing"
HOMEPAGE="https://github.com/sferik/multi_xml"
SRC_URI="https://github.com/sferik/multi_xml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc test"

ruby_add_rdepend "|| ( dev-ruby/bigdecimal:4 >=dev-ruby/bigdecimal-3.1:0 )"

ruby_add_bdepend "doc? ( dev-ruby/yard )"
ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.27:5 dev-ruby/ox )"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/bundler/I s:^:#:' \
		-e '/yardstick/,/end/ s:^:#:' \
		-e '/rubocop/I s:^:#:' \
		-i Rakefile || die

	# Avoid coverage dependencies
	sed -e '/simplecov/,/^end/ s:^:#:' \
		-e '/mutant/ s:^:#:' \
		-e '1igem "minitest", "~> 5.0"' \
		-i test/test_helper.rb || die
	sed -e '/cover/ s:^:#:' \
		-e '/Mutant/ s:^:#:' \
		-i test/*.rb || die

	# Avoid tests for unpackaged XML providers.
	sed -e '/test_returns_oga_when_only_oga_defined/askip "Not packaged"' \
		-i test/parser_detection_test.rb || die
	sed -e '/test_load_parser_handles_underscore_names/askip "Not packaged"' \
		-i test/load_parser_test.rb || die
}

each_ruby_test() {
	CI=true ${RUBY} -Ilib:.:test -e "Dir['test/**/*.rb'].each{|f| require f}" || die
}
