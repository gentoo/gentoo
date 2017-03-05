# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="nanoc is a simple but very flexible static site generator written in Ruby"
HOMEPAGE="http://nanoc.ws/"
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
	>=dev-ruby/cri-2.3:0
	dev-ruby/ddplugin:1
	=dev-ruby/hamster-3*
	dev-ruby/ref:2"

ruby_add_bdepend "test? (
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
	sed -i -e '/simplecov/I s:^:#:' test/helper.rb || die
	sed -i -e '/coverall/I s:^:#:' \
		-e '/rubocop/ s:^:#:' Rakefile || die

	# Avoid tests requiring a network connection
	rm -f test/checking/checks/test_{css,html}.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake test_all || die
}
