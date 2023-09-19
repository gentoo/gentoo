# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

MY_P=elasticsearch-ruby-${PV}
DESCRIPTION="Ruby integrations for ES, elasticsearch module"
HOMEPAGE="https://github.com/elastic/elasticsearch-ruby"
SRC_URI="https://github.com/elastic/elasticsearch-ruby/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1-3)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	~dev-ruby/elasticsearch-api-${PV}
	~dev-ruby/elasticsearch-transport-${PV}
"
ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? (
		dev-ruby/ansi
		dev-ruby/elasticsearch-transport
		dev-ruby/mocha:1.0
		dev-ruby/pry
		dev-ruby/shoulda-context
	)
"

RUBY_S=${MY_P}/${PN}

all_ruby_prepare() {
	# fix to work without git
	sed -i -e 's/git ls-files/find * -type f/' *.gemspec || die

	# remove useless dependencies from Rakefile
	sed -e '/bundler/d' \
		-e '/require.*cane/,/end/d' \
		-i Rakefile || die

	sed -e '/documentation/ s:^:#:' \
		-i spec/spec_helper.rb || die

	# Avoid spec requiring a running elasticsearch server
	rm -f spec/integration/{characters_escaping,client_integration,validation_integration}_spec.rb || die
}
