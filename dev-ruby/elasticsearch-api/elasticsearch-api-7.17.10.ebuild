# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"
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
IUSE=""

ruby_add_rdepend "
	dev-ruby/multi_json
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

	sed -i -e '/config.formatter/ s/documentation/progress/' spec/spec_helper.rb || die

	# Avoid tests that require unpackaged jbuilder and jsonify
	sed -e '/\(pry-\|jbuilder\|jsonify\)/ s:^:#:' \
		-e '/RspecJunitFormatter/ s:^:#:' \
		-i spec/spec_helper.rb || die
	rm -f spec/elasticsearch/api/actions/json_builders_spec.rb || die

	sed -i -e '/uses the escape_utils gem/askip "unmaintained gem"' spec/elasticsearch/api/utils_spec.rb || die
}
