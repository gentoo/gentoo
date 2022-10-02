# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Very lightweight libcurl wrapper"
HOMEPAGE="https://github.com/typhoeus/ethon"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND+=" net-misc/curl"

ruby_add_rdepend ">=dev-ruby/ffi-1.15.0"

ruby_add_bdepend "test? ( dev-ruby/sinatra dev-ruby/mime-types )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/bundler/I s:^:#:' \
		-e '1igem "sinatra"' -i Rakefile spec/spec_helper.rb || die
}
