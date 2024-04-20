# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="twitter.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby wrapper around the Twitter API"
HOMEPAGE="https://github.com/sferik/twitter-ruby/"
SRC_URI="https://github.com/sferik/twitter-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="twitter-ruby-${PV}"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.3
	=dev-ruby/buftok-0.3.0*
	>=dev-ruby/equalizer-0.0.11
	=dev-ruby/equalizer-0.0*
	>=dev-ruby/http-5.1:5
	>=dev-ruby/http-form_data-2.3:2
	=dev-ruby/llhttp-ffi-0.4*
	=dev-ruby/memoizable-0.4*
	=dev-ruby/multipart-post-2*
	>=dev-ruby/naught-1.1
	=dev-ruby/simple_oauth-0.3*
"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/webmock:3
	>=dev-ruby/timecop-0.6.1
	)
	doc? ( dev-ruby/yard )"

all_ruby_prepare() {
#	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die "Unable to remove bundler code."

	sed -i -e '/simplecov/,/^end/ s:^:#:' \
		-e '1igem "webmock", "~>3.0"' spec/helper.rb || die

	# Avoid a spec that fails due to changes in dependencies.
	sed -i -e '/#reverse_token/,/^  end/ s:^:#:' \
		spec/twitter/rest/oauth_spec.rb
}

each_ruby_test() {
	CI=true RSPEC_VERSION=3 ruby-ng_rspec || die
}
