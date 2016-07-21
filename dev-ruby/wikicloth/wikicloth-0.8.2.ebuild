# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README README.textile"

inherit ruby-fakegem

DESCRIPTION="A mediawiki parser"
HOMEPAGE="https://github.com/nricciar/wikicloth"
SRC_URI="https://github.com/nricciar/wikicloth/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/builder
	dev-ruby/expression_parser
	dev-ruby/rinku"
ruby_add_bdepend "test? (
	dev-ruby/activesupport
	dev-ruby/test-unit
	dev-ruby/i18n )"

all_ruby_prepare() {
	sed -i \
		-e '/[Bb]undler/d' \
		-e "/require 'simplecov'/d" \
		Rakefile || die "sed failed"
}

each_ruby_test() {
	${RUBY} -Ilib:test test/wiki_cloth_test.rb || die
}
