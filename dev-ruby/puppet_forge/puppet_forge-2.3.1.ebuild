# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_EXTRAINSTALL=locales

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Tools to access Forge API information on Modules, Users, and Releases"
HOMEPAGE="https://github.com/puppetlabs/forge-ruby"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/faraday-0.9.0:0
	>=dev-ruby/faraday_middleware-0.9.0:0
	>=dev-ruby/gettext-setup-0.11:0
	dev-ruby/minitar
	=dev-ruby/semantic_puppet-1*
"

all_ruby_prepare() {
	# Avoid integration and user specs since they all require network access
	rm -rf spec/integration spec/unit/forge/v3/user_spec.rb || die

	# Fix overly restrictive dependencies
	sed -i \
		-e '/faraday/ s/0.15.0/0.99.0/' \
		-e '/faraday_middleware/ s/0.13.0/0.99.0/' \
		${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
