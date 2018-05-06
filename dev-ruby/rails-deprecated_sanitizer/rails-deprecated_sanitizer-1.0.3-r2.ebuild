# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Deprecated sanitizer API extracted from Action View"
HOMEPAGE="https://github.com/rails/rails-deprecated_sanitizer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86 ~amd64-linux"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-4.2"

ruby_add_bdepend "test? ( >=dev-ruby/actionview-4.2 )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
