# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="A ruby parser written in pure ruby"
HOMEPAGE="https://github.com/seattlerb/ruby_parser"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/sexp_processor-4.16.0:4"

ruby_add_bdepend "test? ( dev-ruby/racc >=dev-ruby/minitest-4.3 >=dev-ruby/sexp_processor-4.17.0:4 )"

DEPEND+=" test? ( dev-util/unifdef )"

all_ruby_prepare() {
	sed -i -e '/license/d' Rakefile || die
	sed -i -e '/Hoe.plugin :isolate/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
