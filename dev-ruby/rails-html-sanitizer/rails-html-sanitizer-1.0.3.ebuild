# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Sanitize HTML fragments in Rails applications"
HOMEPAGE="https://github.com/rafaelfranca/rails-html-sanitizer"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

ruby_add_rdepend "dev-ruby/loofah:0"

ruby_add_bdepend "test? ( dev-ruby/rails-dom-testing )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
