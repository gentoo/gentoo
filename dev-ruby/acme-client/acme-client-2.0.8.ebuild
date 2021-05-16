# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="acme-client.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Ruby client for the letsencrypt's ACME protocol."
HOMEPAGE="https://github.com/unixcharles/acme-client"
SRC_URI="https://github.com/unixcharles/acme-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "|| ( dev-ruby/faraday:1 >=dev-ruby/faraday-0.17:0 )"

ruby_add_bdepend "test? (
	>=dev-ruby/vcr-2.9.3
	>=dev-ruby/webmock-3.8:3
)"

all_ruby_prepare() {
	# Avoid dependency on git
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
