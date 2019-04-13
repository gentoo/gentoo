# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="test"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="http://rails-i18n.org/"

LICENSE="MIT"
SLOT="0.6"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=( ${PN}-0.7.0-frozen-classes.patch )

ruby_add_bdepend "test? ( dev-ruby/activesupport
	dev-ruby/mocha:1.0
	dev-ruby/test_declarative
	dev-ruby/minitest:0 )"

each_ruby_test() {
	${RUBY} -w -Ilib -Itest test/all.rb || die
}

all_ruby_prepare() {
	#Bundler isn't really necessary here, and it doesn't work with jruby
	#Tests fail for jruby with >=mocha-0.13 unless we also include the
	#test-unit gem. jruby also requires an explicit require of 'set'.
	#Tests are cannot be run in random order, so use a minitest version that does not do this.
	sed -i -e "/require 'bundler\/setup'/ s:^:#:" \
		-e '1irequire "set"; gem "minitest", "~> 4.0"' \
		-e "/require 'test\\/unit'/i gem 'test-unit'" test/test_helper.rb || die
}
