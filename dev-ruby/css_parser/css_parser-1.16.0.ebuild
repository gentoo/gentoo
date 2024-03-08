# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_DOC_DIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md "
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="premailer"
GITHUB_PROJECT="${PN}"
inherit ruby-fakegem

DESCRIPTION="Sass-based Stylesheet Framework"
HOMEPAGE="https://github.com/premailer/css_parser/"
LICENSE="MIT"

SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/v${PV}.tar.gz -> ${GITHUB_PROJECT}-${PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc test"

ruby_add_rdepend "dev-ruby/addressable
	virtual/ruby-ssl"

ruby_add_bdepend "test? ( dev-ruby/maxitest dev-ruby/webrick )"

all_ruby_prepare() {
	# get rid of bundler usage
	rm Gemfile || die
	sed -i -e '/bundler/d' -e '/bump/d' Rakefile || die
	sed -i -e '/bundler/d' test/test_helper.rb || die
	# Avoid tests using the network.
	sed -i -e '/test_loading_a_remote_file_over_ssl/,/end/ s:^:#:' test/test_css_parser_loading.rb || die

}

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die
}
