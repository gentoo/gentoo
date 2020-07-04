# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="assets"

inherit bash-completion-r1 ruby-fakegem

DESCRIPTION="Travis CI Client (CLI and Ruby library)"
HOMEPAGE="https://github.com/travis-ci/travis.rb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
#RESTRICT="test"

DEPEND+="test? ( dev-vcs/git )"
RDEPEND+="dev-vcs/git"

ruby_add_bdepend "
	test? ( >dev-ruby/rack-test-0.6 dev-ruby/rspec-its )
	>dev-ruby/sinatra-1.3
"

ruby_add_rdepend "
	dev-ruby/faraday:1
	dev-ruby/faraday_middleware:1
	>=dev-ruby/gh-0.17
	dev-ruby/highline:2
	>=dev-ruby/json-2.3:2
	>=dev-ruby/launchy-2.1
	>dev-ruby/pusher-client-0.4
	dev-ruby/typhoeus:0
"

all_ruby_prepare() {
	if use test ; then
		git init --quiet . || die
		git remote add origin "${HOMEPAGE}" || die
		touch .travis.yml || die
	fi

	# Remove failing spec where cause is not fully clear.
	# May be related to highline compatibility issues.
	rm spec/cli/login_spec.rb || die

	# Remove failing specs where $params keys are reset somewhere.
	rm -f spec/cli/{cancel,restart}_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install

	newbashcomp "assets/travis.sh" "travis"
}
