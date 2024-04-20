# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md CONTRIBUTING.md HISTORY.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
# rspec tests have dependencies not packaged in Gentoo at this time:
# puppetlabs_spec_helper
# CFPropertyList
# simplecov-console
# spec-puppet
# rubocop
# rubocop-rspec
# license_finder
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="This library provides a simple way to write new native resources for puppet."
HOMEPAGE="https://rubygems.org/gems/puppet-resource_api https://github.com/puppetlabs/puppet-resource_api"
LICENSE="MIT"
# 2023/03/19: .gem does not contain specfiles, and lags behind GitHub releases.
SRC_URI="https://github.com/puppetlabs/puppet-resource_api/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

all_ruby_prepare() {
	# the gemspec tries to system(git ls-files) but has a meaningful fallback, so just make it not run git.
	sed -e 's:__FILE__:"puppet-resource_api.gemspec":' \
		-e 's/__dir__/"."/' \
		-i "${RUBY_FAKEGEM_GEMSPEC}" \
		|| die
}

ruby_add_rdepend ">=dev-ruby/hocon-1.0"
