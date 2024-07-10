# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="docker-api.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A simple REST client for the Docker Remote API"
HOMEPAGE="https://github.com/upserve/docker-api"
SRC_URI="https://github.com/upserve/docker-api/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/excon-0.64.0
	dev-ruby/multi_json
"

ruby_add_bdepend "test? ( dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files/find */' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' -e '/formatter/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/\(single_cov\|SingleCov\)/ s:^:#:' spec/*.rb spec/*/*.rb || die
	rm -f spec/cov_spec.rb || die

	# Avoid specs requiring a running docker daemon
	rm -f spec/docker_spec.rb spec/docker/{container,event,exec,image,network,volume}_spec.rb || die
}
