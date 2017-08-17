# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="API for JIRA"
HOMEPAGE="https://github.com/sumoheavy/jira-ruby https://rubygems.org/gems/jira-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/activesupport:*
	dev-ruby/multipart-post
	>=dev-ruby/oauth-0.5.0
	<dev-ruby/oauth-1"

ruby_add_bdepend "test? (
	dev-ruby/railties
	>=dev-ruby/webmock-1.18.0:0
	dev-ruby/rake )"

DEPEND="${DEPEND} test? ( dev-libs/openssl:0 )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" \
		-e '1igem "webmock", "~>1.0"' \
		spec/spec_helper.rb || die
	sed -i -e '/git ls-files/d' ${PN}.gemspec || die
}

each_ruby_test() {
	${RUBY} -S rake jira:generate_public_cert || die
	RSPEC_VERSION=3 ruby-ng_rspec || die
}
