# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="https://nanoc.ws/"
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
	>=dev-ruby/cri-2.15:0
	dev-ruby/ddmemoize:1
	dev-ruby/ddmetrics:1
	dev-ruby/ddplugin:1
	=dev-ruby/hamster-3*
	>=dev-ruby/json_schema-0.19:0
	>=dev-ruby/parallel-1.12:1
	dev-ruby/ref:2
	>=dev-ruby/slow_enumerator_tools-1.1.0:1
	>=dev-ruby/tomlrb-1.2:1"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/asciidoctor
	dev-ruby/fuubar
	dev-ruby/maruku
	>=dev-ruby/mocha-0.13
	dev-ruby/minitest
	dev-ruby/pry
	dev-ruby/rdoc
	dev-ruby/rouge:2
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
	sed -i -e '/simplecov/,/SimpleCov.formatter/ s:^:#:' test/helper.rb || die
	sed -i -e '/simplecov/I s:^:#:' \
		-e '/codecov/I s:^:#:' ../common/spec/spec_helper_head.rb || die
	sed -i -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' Rakefile || die

	echo "-r ./spec/spec_helper.rb" > .rspec || die

	# Avoid tests requiring a network connection
	rm -f test/checking/checks/test_{css,html}.rb || die

	# Avoid tests for unpackaged dependencies
	rm spec/nanoc/deploying/fog_spec.rb \
	   spec/nanoc/filters/less_spec.rb \
	   test/filters/test_{markaby,rainpress}.rb || die

	# Use useable tmp dir
	sed -i -e 's:/tmp/whatever:'${T}'/whatever:' spec/nanoc/base/checksummer_spec.rb || die

	# Avoid non-fatal failing tests due to specifics in the environment
	sed -i -e '145askip "gentoo"' spec/nanoc/cli/error_handler_spec.rb || die
	sed -i -e '/does not crash when output dir does not exist and/askip "gentoo"' spec/nanoc/cli/commands/view_spec.rb || die
	sed -i -e '/watches with --watch/askip "gentoo"' spec/nanoc/cli/commands/compile_spec.rb || die
	sed -i -e '124askip "ordering issues"' -e '168askip "ordering issues"' spec/nanoc/data_sources/filesystem_spec.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake spec test_all || die
}
