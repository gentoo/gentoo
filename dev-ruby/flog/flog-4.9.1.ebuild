# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Flog reports the most tortured code in an easy to read pain report"
HOMEPAGE="https://ruby.sadi.st/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

ruby_add_rdepend "
	dev-ruby/path_expander:2
	>=dev-ruby/prism-1.7:1
	>=dev-ruby/sexp_processor-4.8:4"

each_ruby_test() {
	${RUBY} -Ilib test/test_flog.rb || die
}
