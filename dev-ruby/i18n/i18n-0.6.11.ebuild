# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/i18n/i18n-0.6.11.ebuild,v 1.5 2014/12/31 12:18:07 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="test"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="http://rails-i18n.org/"

LICENSE="MIT"
SLOT="0.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/activesupport
	dev-ruby/mocha:1.0
	dev-ruby/test_declarative
	dev-ruby/test-unit:2 )"

each_ruby_test() {
	${RUBY} -w -Ilib -Itest test/all.rb || die
}

all_ruby_prepare() {
	#Bundler isn't really necessary here, and it doesn't work with jruby
	#Tests fail for jruby with >=mocha-0.13 unless we also include the
	#test-unit gem. jruby also requires an explicit require of 'set'.
	sed -i -e "/require 'bundler\/setup'/ s:^:#:" \
		-e '1irequire "set"' \
		-e "/require 'test\\/unit'/i gem 'test-unit'" test/test_helper.rb || die
}
