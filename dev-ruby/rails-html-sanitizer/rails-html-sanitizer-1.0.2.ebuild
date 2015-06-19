# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails-html-sanitizer/rails-html-sanitizer-1.0.2.ebuild,v 1.3 2015/04/11 15:22:04 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Sanitize HTML fragments in Rails applications"
HOMEPAGE="https://github.com/rafaelfranca/rails-html-sanitizer"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

ruby_add_rdepend "dev-ruby/loofah:0"

ruby_add_bdepend "test? ( dev-ruby/rails-dom-testing )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
