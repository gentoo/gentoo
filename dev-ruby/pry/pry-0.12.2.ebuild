# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_GEMSPEC=${PN}.gemspec

inherit ruby-fakegem

DESCRIPTION="Pry is a powerful alternative to the standard IRB shell for Ruby"
HOMEPAGE="https://github.com/pry/pry/wiki"
SRC_URI="https://github.com/pry/pry/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE=""
SLOT="ruby19"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"

ruby_add_rdepend "
	>=dev-ruby/coderay-1.1.0 =dev-ruby/coderay-1.1*
	>=dev-ruby/method_source-0.9.0 =dev-ruby/method_source-0.9*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/open4-1.3
		>=dev-ruby/rake-0.9
		>=dev-ruby/mocha-1.0
	)"

all_ruby_prepare() {
	# Avoid unneeded dependency on git.
	# Loosen coderay dependency.
	sed -e '/git ls-files/d' \
		-e '/coderay/s/~>/>=/' \
		-e '/bundler/d' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/[Bb]undler/d' -e "1irequire 'mocha/api'\ " -i spec/helper.rb || die
	# Out of date tests
	rm spec/commands/gist_spec.rb || die
}
