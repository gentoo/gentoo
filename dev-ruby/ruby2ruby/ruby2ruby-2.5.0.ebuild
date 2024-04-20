# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="Generates readable ruby from ParseTree"
HOMEPAGE="https://github.com/seattlerb/ruby2ruby"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/sexp_processor-4.6.0:4
	>=dev-ruby/ruby_parser-3.1:3
"
ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.3:5 >=dev-ruby/sexp_processor-4.10.0:4 )"

all_ruby_prepare() {
	sed -i -e '/plugin :isolate/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
