# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit bash-completion-r1 ruby-fakegem

DESCRIPTION="Travis CI Client (CLI and Ruby library) "
HOMEPAGE="https://github.com/travis-ci/travis.rb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

ruby_add_bdepend "
	test? ( >dev-ruby/rack-test-0.6 )
	>dev-ruby/sinatra-1.3
"

ruby_add_rdepend "
	dev-ruby/backports
	>dev-ruby/faraday-0.9
	>=dev-ruby/faraday_middleware-0.9.1
	>dev-ruby/gh-0.13
	>dev-ruby/highline-1.6
	>dev-ruby/launchy-2.1
	>dev-ruby/pusher-client-0.4
	>=dev-ruby/typhoeus-0.6.8
"

all_ruby_install() {
	all_fakegem_install

	newbashcomp "assets/travis.sh" "travis"
}
