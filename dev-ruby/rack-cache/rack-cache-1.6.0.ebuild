# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

# no documentation is generable, it needs hanna, which is broken
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md doc/*"

inherit versionator ruby-fakegem

DESCRIPTION="Enable HTTP caching for Rack-based applications that produce freshness info"
HOMEPAGE="https://github.com/rtomayko/rack-cache"
SRC_URI="https://github.com/rtomayko/rack-cache/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.2"
KEYWORDS="~amd64 ~arm ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/rack:*"

ruby_add_bdepend "test? (
	dev-ruby/maxitest
	>=dev-ruby/minitest-5.7.0:5
	>=dev-ruby/mocha-0.13.0 )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' \
		-e "2i require 'timeout'" \
		test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib:test -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
