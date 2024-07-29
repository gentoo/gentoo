# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRA_DOC="CHANGELOG.md README.md"

#RUBY_FAKEGEM_GEMSPEC="mixlib-shellout.gemspec"

inherit ruby-fakegem

DESCRIPTION="Basic utility functions for Core Chef Infra development"
HOMEPAGE="https://github.com/chef/chef/tree/main/chef-utils"
#SRC_URI="https://github.com/chef/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/concurrent-ruby"

all_ruby_prepare() {
	# Avoid specs depending on unpackaged fauxhai
	rm -f spec/unit/dsl/{cloud,os,platform,platform_family,virtualization}_spec.rb || die
}
