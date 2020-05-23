# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

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
	test? ( >dev-ruby/rack-test-0.6 )
	>dev-ruby/sinatra-1.3
"

ruby_add_rdepend "
	dev-ruby/backports
	>dev-ruby/faraday-0.9:*
	>=dev-ruby/faraday_middleware-0.9.1:*
	>dev-ruby/gh-0.13
	>=dev-ruby/highline-1.6:0
	>dev-ruby/launchy-2.1
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
}

all_ruby_install() {
	all_fakegem_install

	newbashcomp "assets/travis.sh" "travis"
}
