# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit versionator ruby-fakegem

DESCRIPTION="Rack::Test is a small, simple testing API for Rack apps"
HOMEPAGE="https://github.com/rack-test/rack-test"
SRC_URI="https://github.com/rack-test/rack-test/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0:* <dev-ruby/rack-3:*"
ruby_add_bdepend "
	test? ( >=dev-ruby/sinatra-1.2.6 =dev-ruby/rack-1* )"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -i -e '/bundler/d' -e '/[Cc]ode[Cc]limate/d' \
		-e '1igem "rack", "~>1.0"' spec/spec_helper.rb || die

	# Use correct version
	sed -i -e 's/0.8.2/0.8.3/' lib/rack/test/version.rb || die
}
