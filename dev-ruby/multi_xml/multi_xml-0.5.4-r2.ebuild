# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC="doc:yard"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A generic swappable back-end for XML parsing"
HOMEPAGE="http://rdoc.info/gems/multi_xml"
LICENSE="MIT"

KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.start/ s:^:#:' spec/helper.rb || die
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_test() {
	CI=true each_fakegem_test
}
