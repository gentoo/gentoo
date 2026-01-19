# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRA_DOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Basic utility functions for Core Chef Infra development"
HOMEPAGE="https://github.com/chef/chef/tree/main/chef-utils"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "dev-ruby/concurrent-ruby"

all_ruby_prepare() {
	# Avoid specs depending on unpackaged fauxhai
	rm -f spec/unit/dsl/{cloud,os,platform,platform_family,virtualization}_spec.rb || die
}
