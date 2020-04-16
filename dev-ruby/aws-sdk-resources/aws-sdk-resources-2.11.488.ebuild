# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRAINSTALL="resources.schema.json"

GITHUB_USER="aws"
GITHUB_PROJECT="aws-sdk-ruby"
RUBY_S="${GITHUB_PROJECT}-${PV}/${PN}"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Official SDK for Amazon Web Services"
HOMEPAGE="https://aws.amazon.com/sdkforruby"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/v${PV}.tar.gz -> ${GITHUB_PROJECT}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "~dev-ruby/aws-sdk-core-${PV}"

ruby_add_bdepend "dev-ruby/webmock"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}
