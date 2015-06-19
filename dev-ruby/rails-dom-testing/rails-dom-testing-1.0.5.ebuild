# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails-dom-testing/rails-dom-testing-1.0.5.ebuild,v 1.4 2015/01/08 20:52:48 maekke Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Compare doms and assert certain elements exists in doms using Nokogiri"
HOMEPAGE="https://github.com/kaspth/rails-dom-testing"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/nokogiri-1.6.0
	>=dev-ruby/rails-deprecated_sanitizer-1.0.1"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
