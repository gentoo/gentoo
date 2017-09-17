# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="https://nanoc.ws/"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="${IUSE} minimal"

DEPEND+="test? ( app-text/asciidoc app-text/highlight )"

ruby_add_rdepend "!minimal? (
	dev-ruby/mime-types:*
	dev-ruby/rack:*
	www-servers/adsf
)
	>=dev-ruby/cri-2.8:0
	dev-ruby/ddplugin:1
	=dev-ruby/hamster-3*
	dev-ruby/ref:2"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/fuubar
	>=dev-ruby/mocha-0.13
	dev-ruby/minitest
	dev-ruby/rdoc
	dev-ruby/systemu
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
	sed -i -e '/simplecov/I s:^:#:' -e '/codecov/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' Rakefile || die

	echo "-r ./spec/spec_helper.rb" > .rspec || die

	# Avoid tests requiring a network connection
	rm -f test/checking/checks/test_{css,html}.rb || die

	# Avoid tests for unpackaged dependencies
	rm spec/nanoc/deploying/fog_spec.rb spec/nanoc/filters/less_spec.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake spec test_all || die
}
