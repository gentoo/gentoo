# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rack::Test is a small, simple testing API for Rack apps"
HOMEPAGE="https://github.com/rack-test/rack-test"
SRC_URI="https://github.com/rack-test/rack-test/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0:* <dev-ruby/rack-3:*"
ruby_add_bdepend "
	test? ( dev-ruby/sinatra:2 )"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -e '/bundler/d' \
		-e '/[Cc]ode[Cc]limate/d' \
		-e '/simplecov/,/^end/ s:^:#:' \
		-i spec/spec_helper.rb || die
	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid test broken with rack 2.2
	sed -i -e '/closes response.s body/askip "rack 2.2 compatibility"' spec/rack/test_spec.rb || die
}
