# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Tools to access Forge API information on Modules, Users, and Releases"
HOMEPAGE="https://github.com/puppetlabs/forge-ruby"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${PN}-5.0.1-typhoeus.patch" )

ruby_add_rdepend "
	|| ( dev-ruby/base64:0.3 dev-ruby/base64:0.2 )
	dev-ruby/faraday:2
	|| ( dev-ruby/faraday-follow_redirects:0.4 dev-ruby/faraday-follow_redirects:0.3 )
	>=dev-ruby/minitar-1.0.2:1
	=dev-ruby/semantic_puppet-1*
"

all_ruby_prepare() {
	# Avoid integration and user specs since they all require network access
	rm -rf spec/integration spec/unit/forge/v3/user_spec.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
