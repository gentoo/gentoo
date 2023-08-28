# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_GEMSPEC="vagrant_cloud.gemspec"

inherit ruby-fakegem

DESCRIPTION="Vagrant Cloud API Library"
HOMEPAGE="https://github.com/hashicorp/vagrant_cloud"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/excon-0.73
	>=dev-ruby/log4r-1.1.10
"
ruby_add_bdepend ">=dev-ruby/rake-12.3
	test? (
		>=dev-ruby/webmock-3.0
	)
"

all_ruby_prepare() {
	# # loosen dependencies
	sed -e 's:require_relative ":require "./:' \
		-e '/excon/s/~>/>=/' \
		-e '/log4r/s/~>/>=/' \
		-e '/rake/s/~>/>=/' \
		-e '/rspec/s/~>/>=/' \
		-e '/webmock/s/~>/>=/' \
		-i ${PN}.gemspec || die
}
