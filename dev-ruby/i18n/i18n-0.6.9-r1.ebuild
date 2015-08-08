# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="test"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="Add Internationalization support to your Ruby application"
HOMEPAGE="http://rails-i18n.org/"

LICENSE="MIT"
SLOT="0.6"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/activesupport
	dev-ruby/mocha:0.13
	dev-ruby/test_declarative
	dev-ruby/test-unit:2 )"

each_ruby_test() {
	${RUBY} -w -Ilib -Itest test/all.rb || die
}

all_ruby_prepare() {
	#Bundler isn't really necessary here, and it doesn't work with jruby
	#Tests fail for jruby with >=mocha-0.13 unless we also include the
	#test-unit gem.
	sed -i -e "15s/require 'bundler\/setup'//"\
		-e "/require 'mocha'/i gem 'mocha', '~>0.13.0'" \
		-e "/require 'test\\/unit'/i gem 'test-unit'" test/test_helper.rb || die
}
