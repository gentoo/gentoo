# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true test:core"

RUBY_FAKEGEM_EXTRADOC="README.md AUTHORS.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="sinatra.gemspec"

inherit ruby-fakegem

DESCRIPTION="A DSL for quickly creating web applications in Ruby with minimal effort"
HOMEPAGE="https://sinatrarb.com/"
SRC_URI="https://github.com/sinatra/sinatra/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc test"

ruby_add_rdepend "
	>=dev-ruby/logger-1.6.0
	dev-ruby/mustermann:3
	|| ( dev-ruby/rack:3.2 dev-ruby/rack:3.1 dev-ruby/rack:3.0 )
	~dev-ruby/rack-protection-${PV}
	dev-ruby/rack-session:2
	dev-ruby/tilt:2"

# dev-ruby/haml is an optional test dependency, but it will lead to
# circular dependencies so we don't require it for tests.
ruby_add_bdepend "
	test? (
		dev-ruby/activesupport
		dev-ruby/builder
		dev-ruby/bundler
		dev-ruby/erubi
		dev-ruby/minitest:5
		dev-ruby/mustermann
		dev-ruby/rackup
		>=dev-ruby/rack-test-0.5.6
		dev-ruby/tilt
		www-servers/puma
	)
"
ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	sed -i \
		-e "/require 'rack'/igem 'rack', '>= 3.0.0';" \
		test/test_helper.rb || die

	cat <<-EOF > "${T}/Gemfile" || die
	gem "activesupport"
	gem "builder"
	gem "erubi"
	gem "minitest", "~> 5"
	gem "mustermann"
	gem "puma"
	gem "rack-protection"
	gem "rack-session"
	gem "rack-test"
	gem "rackup"
	gem "rake"
	gem "tilt"
	EOF
}

each_ruby_test() {
	BUNDLE_GEMFILE="${T}/Gemfile" MT_NO_PLUGINS=true ${RUBY} -S bundle exec ${RUBY} -S rake test:core || die
}
