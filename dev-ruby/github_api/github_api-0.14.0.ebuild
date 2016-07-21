# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Ruby wrapper for the GitHub REST API v3"
HOMEPAGE="https://github.com/peter-murach/github"
SRC_URI="https://github.com/peter-murach/github/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="github-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/addressable-2.4
	>=dev-ruby/descendants_tracker-0.0.4
	>=dev-ruby/faraday-0.8
	<dev-ruby/faraday-0.10
	>=dev-ruby/hashie-3.4
	dev-ruby/oauth2"

ruby_add_bdepend "test? ( >=dev-ruby/rspec-2.14 dev-ruby/webmock )"

all_ruby_prepare() {
	# Work around or avoid webmock incompatibilities
	files=$(grep -R -l "with(inputs)" spec)
	sed -i -e 's/\.with(inputs)//' \
		-e 's/\.with(inputs.except(.*))//' ${files} || die
	sed -i -e 's/.with(hub_inputs.*)//' spec/github/client/repos/pub_sub_hubbub/*subscribe* || die
	sed -i -e 's/.with({})//i' spec/github/client/repos/{list,contributors}_spec.rb || die
	sed -i -e 's/.with({.*})//' spec/github/client/orgs/memberships/edit_spec.rb || die
	rm -f spec/github/error/service_error_spec.rb spec/github/client/authorizations/two_factor_spec.rb || die
}
