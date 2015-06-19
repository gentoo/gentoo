# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mongo/mongo-1.12.0.ebuild,v 1.2 2015/03/09 18:25:41 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test:unit"

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

# This is the same source package as bson, so keep them the same
# version, but not revision
ruby_add_rdepend "~dev-ruby/bson-${PV}"

ruby_add_bdepend \
	"test? (
		dev-ruby/bundler
		>=dev-ruby/rake-10.1
		dev-ruby/sfl
		>=dev-ruby/shoulda-3.3.2
		dev-ruby/mocha
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	# remove the stuff that is actually part of dev-ruby/bson
	rm -f bin/{b2j,j2b}son || die

	# Avoid test dependency on pry
	sed -i -e '/\(pry\|coverall\)/I s:^:#:' Gemfile tasks/testing.rake test/test_helper.rb || die
	# Avoid deployment dependencies and fix version issues
	sed -i -e '/rest-client/ s/1.6.8/~> 1.6/' \
		-e '/test-unit/ s/~>2.0/>= 2.0/' \
		-e '/rake/ s/10.1.1/~>10.1/' \
		-e '/:deploy/,/end/ s:^:#:' Gemfile || die
}

each_ruby_test() {
	JENKINS_CI=true ${RUBY} -S rake test:unit || die "Tests failed."
}

each_ruby_install() {
	# Remove bson code used for testing. This is installed as part of
	# dev-ruby/bson.
	rm -rf lib/bson* || die

	each_fakegem_install
}
