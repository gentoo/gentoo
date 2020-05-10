# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rack::Test is a small, simple testing API for Rack apps"
HOMEPAGE="https://github.com/rack-test/rack-test"
SRC_URI="https://github.com/rack-test/rack-test/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0:* <dev-ruby/rack-3:*"
ruby_add_bdepend "
	test? ( dev-ruby/sinatra:2 || ( dev-ruby/rack:2.1 dev-ruby/rack:2.0 ) )"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -e '/bundler/d' \
		-e '/[Cc]ode[Cc]limate/d' \
		-e '/simplecov/,/^end/ s:^:#:' \
		-e '1igem "rack", "<2.2"' \
		-i spec/spec_helper.rb || die
	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
