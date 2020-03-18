# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_TASK_DOC=doc

inherit ruby-fakegem

MY_P=elasticsearch-ruby-${PV}
DESCRIPTION="Ruby integrations for ES, elasticsearch module"
HOMEPAGE="https://github.com/elastic/elasticsearch-ruby"
SRC_URI="https://github.com/elastic/elasticsearch-ruby/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
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

# Tests need additional modules (at least 'turn') packaged. Then someone
# should look into running them and so on.
RESTRICT="test"

RUBY_S=${MY_P}/${PN}

all_ruby_prepare() {
	# fix to work without git
	sed -i -e 's/git ls-files/find -type f/' *.gemspec || die

	# remove useless dependencies from Rakefile
	sed -e '/bundler/d' \
		-e '/require.*cane/,/end/d' \
		-i Rakefile || die
}
