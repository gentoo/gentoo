# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="mongodb"
GITHUB_PROJECT="mongo-ruby-driver"
RUBY_S="${GITHUB_PROJECT}-${PV}"

inherit ruby-fakegem

DESCRIPTION="A Ruby driver for MongoDB"
HOMEPAGE="http://www.mongodb.org/"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/${PV}.tar.gz -> ${GITHUB_PROJECT}-${PV}.tar.gz"

LICENSE="APSL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/bson:3"

DEPEND+=" test? ( dev-db/mongodb )"

# Requires a running mongod
RESTRICT="test"

all_ruby_prepare() {
	# Avoid test dependency on pry
	sed -i -e '/\(pry\|coverall\)/I s:^:#:' \
		-e '/simplecov/,/^  end/ s:^:#:' \
		-e '/config.formatter/ s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's/localhost/127.0.0.1/' spec/mongo/*_spec.rb || die

	rm -f .rspec || die
}

each_ruby_test() {
	CI=true ruby-ng_rspec
}

each_ruby_install() {
	# Remove bson code used for testing. This is installed as part of
	# dev-ruby/bson.
#	rm -rf lib/bson* || die

	each_fakegem_install
}
