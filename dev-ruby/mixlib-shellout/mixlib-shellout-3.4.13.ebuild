# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRA_DOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="mixlib-shellout.gemspec"

inherit ruby-fakegem

DESCRIPTION="Run external commands on Unix or Windows"
HOMEPAGE="https://github.com/chef/mixlib-shellout"
SRC_URI="https://github.com/chef/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "dev-ruby/chef-utils dev-ruby/logger"

each_ruby_prepare() {
	# Make sure we actually use the right interpreter for testing
	sed -i -e "/ruby_eval/ s:ruby :${RUBY} :" spec/mixlib/shellout_spec.rb || die

	# Avoid spec that requires an interactive terminal
	sed -e '/with subprocess writing lots of data to both stdout and stderr/,/^      end/ s:^:#:' \
		-i spec/mixlib/shellout_spec.rb || die

	# Avoid known failing specs, bug #978798
	sed -e '/"when cgroup exists"/,/^    end/ s:^:#:' \
		-e '/"when cgroup does not exist"/,/^    end/ s:^:#:' \
		-i spec/mixlib/shellout_spec.rb || die
}
