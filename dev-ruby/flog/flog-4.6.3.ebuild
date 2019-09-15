# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Flog reports the most tortured code in an easy to read pain report"
HOMEPAGE="http://ruby.sadi.st/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

ruby_add_rdepend "
	dev-ruby/path_expander:1
	>dev-ruby/ruby_parser-3.1.0:3
	>=dev-ruby/sexp_processor-4.8:4"

each_ruby_test() {
	${RUBY} -Ilib test/test_flog.rb || die
}
