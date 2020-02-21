# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_EXTRADOC="README.rdoc README.ja.rdoc TODO ChangeLog"

RUBY_FAKEGEM_GEMSPEC="racc.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A LALR(1) parser generator for Ruby"
HOMEPAGE="https://github.com/tenderlove/racc"
SRC_URI="https://github.com/tenderlove/racc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "dev-ruby/rake
	test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e 's|/tmp/out|${TMPDIR:-/tmp}/out|' test/helper.rb || die "tests fix failed"

	# Avoid depending on rake-compiler since we don't use it to compile
	# the extension.
	sed -i -e '/rake-compiler/ s:^:#:' -e '/extensiontask/ s:^:#:' Rakefile
	sed -i -e '/ExtensionTask/,/^  end/ s:^:#:' Rakefile
	# Which means we need to generate the parser file here
	rake lib/racc/parser-text.rb || die

	# Avoid isolation since dependencies are not properly declared.
	sed -i -e 's/, :isolate//' Rakefile || die
}

each_ruby_prepare() {
	${RUBY} -Cext/racc/cparse extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/racc/cparse
	# Copy over the file here so that we don't have to do
	# special ruby install for JRuby and the other
	# implementations.
	mkdir -p lib/racc/cparse || die
	cp -l ext/racc/cparse/cparse$(get_modname) lib/racc/cparse/cparse$(get_modname) || die
}

each_ruby_test() {
	PATH="bin:${PATH}" ${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r rdoc

	docinto examples
	dodoc -r sample
}
