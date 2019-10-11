# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="Generates readable ruby from ParseTree"
HOMEPAGE="https://github.com/seattlerb/ruby2ruby"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/sexp_processor-4.6.0:4
	>=dev-ruby/ruby_parser-3.1:3
	!<dev-ruby/ruby2ruby-1.3.1-r1"
ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.3:5 >=dev-ruby/sexp_processor-4.10.0:4 )"

all_ruby_prepare() {
	sed -i -e '/plugin :isolate/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
