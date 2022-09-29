# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="A concurrency framework for Ruby"
HOMEPAGE="https://github.com/socketry/async"
SRC_URI="https://github.com/socketry/async/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_rdepend ">=dev-ruby/console-1.10:1
	>=dev-ruby/nio4r-2.3:2
	>=dev-ruby/timers-4.1:4"

ruby_add_bdepend "test? (
	>=dev-ruby/async-rspec-1.1:1
	dev-ruby/benchmark-ips
)"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# network tests
	rm -f "spec/async/scheduler_spec.rb" "spec/async/scheduler/address_spec.rb" "spec/async/scheduler/io_spec.rb" || die

	# broken on ruby 3.x
	rm -f "spec/async/condition_spec.rb" "spec/async/notification_spec.rb" || die

	sed -i -E 's/require '"'"'covered\/rspec'"'"'//g' "spec/spec_helper.rb" || die
}
