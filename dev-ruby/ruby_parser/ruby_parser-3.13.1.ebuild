# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="A ruby parser written in pure ruby"
HOMEPAGE="https://github.com/seattlerb/ruby_parser"

LICENSE="MIT"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/sexp_processor-4.9.0:4
	!<dev-ruby/ruby_parser-2.3.1-r1"

ruby_add_bdepend "test? ( dev-ruby/racc >=dev-ruby/minitest-4.3 >=dev-ruby/sexp_processor-4.12.0:4 )"

DEPEND+=" test? ( dev-util/unifdef )"

all_ruby_prepare() {
	# Remove reference to perforce method that is not in a released
	# version of hoe-seattlerb.
	#sed -i -e '/perforce/d' Rakefile || die
	sed -i -e '/license/d' Rakefile || die
	sed -i -e '/Hoe.plugin :isolate/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
