# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="nanoc.gemspec"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="https://nanoc.app/"
SRC_URI="https://github.com/nanoc/nanoc/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="${IUSE} minimal"

DEPEND+="test? ( app-text/asciidoc app-text/highlight )"

RUBY_S="${P}/nanoc"

ruby_add_rdepend "!minimal? (
	dev-ruby/mime-types:*
	dev-ruby/rack:*
	www-servers/adsf
)
	>=dev-ruby/addressable-2.5
	>=dev-ruby/colored-1.2:0
	>=www-apps/nanoc-checking-1.0.2:1
	~www-apps/nanoc-cli-${PV}
	~www-apps/nanoc-core-${PV}
	www-apps/nanoc-deploying:1
	>=dev-ruby/parallel-1.12:1
	>=dev-ruby/tty-command-0.8:0
	>=dev-ruby/tty-which-0.4:0
"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/asciidoctor
	dev-ruby/fuubar
	dev-ruby/haml
	dev-ruby/maruku
	>=dev-ruby/mocha-0.13
	dev-ruby/minitest
	dev-ruby/mustache
	dev-ruby/pry
	dev-ruby/rdoc
	>=dev-ruby/rouge-3.5.1:2
	dev-ruby/rubypants
	dev-ruby/systemu
	dev-ruby/timecop
	dev-ruby/vcr
	dev-ruby/webmock
	dev-ruby/yard
)
doc? (
	dev-ruby/kramdown
	dev-ruby/rdiscount
	dev-ruby/yard
)"

all_ruby_prepare() {
	# Avoid unneeded development dependencies
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/codecov/I s:^:#:' test/helper.rb ../common/spec/spec_helper_head_core.rb || die
	sed -i -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' Rakefile || die

	echo "-r ./spec/spec_helper.rb" > .rspec || die

	# Avoid basepath issues when generating gemspec
	sed -i -e "s:require_relative ':require './:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid tests requiring a network connection or make assumptions
	# about the local network environment.
	rm -f test/checking/checks/test_{css,html}.rb spec/nanoc/cli/commands/view_spec.rb || die

	# Avoid tests for unpackaged dependencies
	rm spec/nanoc/filters/less_spec.rb \
	   test/filters/test_{markaby,rainpress}.rb || die

	# Avoid tests that are specific to haml 6.x which is currently not packaged
	sed -i -e '/test_filter_\(with_proper_indentation\|error\)/askip "haml 6"' test/filters/test_haml.rb || die

	# Avoid non-fatal failing tests due to specifics in the environment
	sed -i -e '124askip "ordering issues"' -e '168askip "ordering issues"' spec/nanoc/data_sources/filesystem_spec.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake spec test_all || die
}
