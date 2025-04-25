# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_TASK_DOC=doc

RUBY_FAKEGEM_TASK_TEST="NOTURN=true test"

inherit ruby-fakegem

MY_P=elasticsearch-ruby-${PV}
DESCRIPTION="Ruby integrations for ES, elasticsearch-api module"
HOMEPAGE="https://github.com/elastic/elasticsearch-ruby"
SRC_URI="https://github.com/elastic/elasticsearch-ruby/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/multi_json
"
ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? (
		dev-ruby/activesupport
		dev-ruby/ansi
		dev-ruby/elasticsearch
		dev-ruby/elastic-transport
		dev-ruby/jbuilder
		dev-ruby/mocha:2
		dev-ruby/patron
		dev-ruby/pry
		dev-ruby/rspec:3
		dev-ruby/shoulda-context
		dev-ruby/yard
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

	sed -i -e '/add_formatter/ s/documentation/progress/' spec/spec_helper.rb || die

	# Avoid tests that require unpackaged jsonify
	sed -e '/\(pry-\|jsonify\)/ s:^:#:' \
		-e '/RspecJunitFormatter/ s:^:#:' \
		-e '/ansi/arequire "patron"' \
		-i spec/spec_helper.rb || die
	sed -e '/context.*Jsonify/ s/context/xcontext/' \
		-i spec/unit/actions/json_builders_spec.rb || die

	# Create tmp directory required for tests
	mkdir -p ../tmp/rest-api-spec/api || die
}
