# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Compare doms and assert certain elements exists in doms using Nokogiri"
HOMEPAGE="https://github.com/kaspth/rails-dom-testing"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activesupport-4.2.0:*
	>=dev-ruby/nokogiri-1.6"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}
