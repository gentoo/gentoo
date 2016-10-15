# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="ChangeLog NEWS.md README.md"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_TASK_TEST="test:all"

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
	=dev-ruby/hamster-3*
	dev-ruby/ref:2"

ruby_add_bdepend "test? (
	>=dev-ruby/mocha-0.13
	dev-ruby/minitest
	=dev-ruby/rdoc-4*
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
	use doc || use test || (rm tasks/doc.rake || die)

	if use test ; then
		# Avoid dependency on coveralls.
		sed -i -e '/coverall/I s:^:#:' tasks/test.rake || die
	else
		rm -f tasks/test.rake || die
	fi

	# Avoid unneeded development dependencies
	rm -f tasks/rubocop.rake || die
	sed -i -e '/simplecov/I s:^:#:' test/helper.rb || die

	# Avoid non-optional tests for w3c_validators which we don't have
	# packaged and which require network access.
	rm test/extra/checking/checks/test_{css,html}.rb || die

	# Skip tests that produce slightly different output.
	sed -i -e '/test_rouge/,418 s:^:#:' test/filters/test_colorize_syntax.rb || die
	sed -i -e '/test_disallow_routes_not_starting_with_slash/,/^  end/ s:^:#:' test/base/test_compiler.rb || die
}

each_ruby_test() {
	RUBYLIB="${S}/lib" ${RUBY} -S rake test:all || die
}
