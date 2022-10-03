# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGES.markdown README.markdown"

inherit ruby-fakegem

DESCRIPTION="Just the partials helper in a gem"
HOMEPAGE="https://github.com/yb66/Sinatra-Partial"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/sinatra-1.4"

ruby_add_bdepend "test? ( dev-ruby/haml dev-ruby/rack-test dev-ruby/rspec-its dev-ruby/timecop )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/spec_helper.rb || die
}
