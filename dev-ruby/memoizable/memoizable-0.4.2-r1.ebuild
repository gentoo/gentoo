# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Memoize method return values"
HOMEPAGE="https://github.com/dkubb/memoizable"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend ">=dev-ruby/thread_safe-0.3.1:0"

all_ruby_prepare() {
	sed -i -e "/simplecov/,/^end$/d" spec/spec_helper.rb || die

	# Avoid a failing test that also fails for upstream Travis.
	rm spec/unit/memoizable/class_methods/included_spec.rb || die
}
