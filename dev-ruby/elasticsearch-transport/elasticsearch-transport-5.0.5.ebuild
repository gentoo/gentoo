# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_DOC=rdoc

RUBY_FAKEGEM_TASK_TEST="NOTURN=true test"

inherit ruby-fakegem

MY_P=elasticsearch-ruby-${PV}
DESCRIPTION="Ruby integrations for ES, elasticsearch-transport module"
HOMEPAGE="https://github.com/elastic/elasticsearch-ruby"
SRC_URI="https://github.com/elastic/elasticsearch-ruby/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/faraday
	dev-ruby/multi_json
"
ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? (
		dev-ruby/ansi
		dev-ruby/mocha:1.0
		dev-ruby/pry
		dev-ruby/shoulda-context
		dev-ruby/curb
		dev-ruby/patron
	)
"

RUBY_S=${MY_P}/${PN}

all_ruby_prepare() {
	# fix to work without git
	sed -i -e 's/git ls-files/find -type f/' *.gemspec || die

	# remove useless dependencies from Rakefile
	sed -e '/bundler/d' \
		-e '/require.*cane/,/end/d' \
		-i Rakefile || die

	# Tweak test setup to only run unit tests since we don't have a live cluster
	sed -i -e "s/RUBY_VERSION > '1.9'/false/" \
		-e '/module Elasticsearch/,$ s:^:#:' test/test_helper.rb || die
}
