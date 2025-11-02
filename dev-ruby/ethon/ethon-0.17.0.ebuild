# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="ethon.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Very lightweight libcurl wrapper"
HOMEPAGE="https://github.com/typhoeus/ethon"
SRC_URI="https://github.com/typhoeus/ethon/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="net-misc/curl"

ruby_add_rdepend ">=dev-ruby/ffi-1.15.0"

ruby_add_bdepend "test? (
	|| ( dev-ruby/rackup dev-ruby/rack:2.2 )
	dev-ruby/sinatra
	dev-ruby/mime-types
	dev-ruby/webrick
)"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/bundler/I s:^:#:' \
		-e '1igem "sinatra"' -i Rakefile spec/spec_helper.rb || die

	sed -e 's/__FILE__/"ethon.gemspec"/' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
