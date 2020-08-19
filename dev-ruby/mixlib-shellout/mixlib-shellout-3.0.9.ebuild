# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRA_DOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="mixlib-shellout.gemspec"

inherit ruby-fakegem

DESCRIPTION="Run external commands on Unix or Windows"
HOMEPAGE="https://github.com/opscode/mixlib-shellout"
SRC_URI="https://github.com/opscode/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

each_ruby_prepare() {
	# Make sure we actually use the right interpreter for testing
	sed -i -e "/ruby_eval/ s:ruby :${RUBY} :" spec/mixlib/shellout_spec.rb || die

	# Avoid spec that requires an interactive terminal
	sed -i -e '/with subprocess writing lots of data to both stdout and stderr/,/^      end/ s:^:#:' spec/mixlib/shellout_spec.rb || die
}
