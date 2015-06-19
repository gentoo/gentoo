# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails-deprecated_sanitizer/rails-deprecated_sanitizer-1.0.3.ebuild,v 1.4 2015/01/08 20:52:16 maekke Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Deprecated sanitizer API extracted from Action View"
HOMEPAGE="https://github.com/rails/rails-deprecated_sanitizer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-4.2"

ruby_add_bdepend "test? ( >=dev-ruby/actionview-4.2 )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
