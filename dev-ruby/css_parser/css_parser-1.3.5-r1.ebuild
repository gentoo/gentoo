# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOC_DIR="doc"
RUBY_FAKEGEM_EXTRADOC="Readme.md"
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="premailer"
GITHUB_PROJECT="${PN}"
inherit ruby-fakegem

DESCRIPTION="Sass-based Stylesheet Framework"
HOMEPAGE="http://compass-style.org/"
LICENSE="MIT"

SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/v${PV}.tar.gz -> ${GITHUB_PROJECT}-${PV}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

ruby_add_rdepend "dev-ruby/addressable
	virtual/ruby-ssl"

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
