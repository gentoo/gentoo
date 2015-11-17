# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

# no documentation is generable, it needs hanna, which is broken
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md doc/*"

inherit versionator ruby-fakegem

DESCRIPTION="A drop-in component to enable HTTP caching for Rack-based applications that produce freshness info"
HOMEPAGE="https://github.com/rtomayko/rack-cache"
SRC_URI="https://github.com/rtomayko/rack-cache/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.2"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

ruby_add_rdepend "dev-ruby/rack:*"

ruby_add_bdepend "test? ( dev-ruby/maxitest )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' \
		-e "2i require 'timeout'" \
		test/spec_setup.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib:test -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
