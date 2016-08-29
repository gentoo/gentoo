# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Compare doms and assert certain elements exists in doms using Nokogiri"
HOMEPAGE="https://github.com/kaspth/rails-dom-testing"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~ppc64 ~amd64-linux"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activesupport-4.2:* <dev-ruby/activesupport-6.0:*
	>=dev-ruby/nokogiri-1.6.0 =dev-ruby/nokogiri-1.6*"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
