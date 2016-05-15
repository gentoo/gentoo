# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md doc/*.rdoc doc/releases/*"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Simple mock object library for Ruby unit testing"
HOMEPAGE="https://github.com/doudou/flexmock"
SRC_URI="https://github.com/doudou/flexmock/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="flexmock"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
		dev-ruby/rspec:3
	)"

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec test/rspec_integration
	${RUBY} -Ilib:.:test -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}

all_ruby_prepare() {
	sed -i -e '1igem "minitest", "~>5.0"' test/test_helper.rb || die
}
