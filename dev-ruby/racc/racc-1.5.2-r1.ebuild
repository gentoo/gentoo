# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_EXTRADOC="README.rdoc README.ja.rdoc TODO ChangeLog"

RUBY_FAKEGEM_GEMSPEC="racc.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/racc/cparse/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/racc/cparse"

inherit multilib ruby-fakegem

DESCRIPTION="A LALR(1) parser generator for Ruby"
HOMEPAGE="https://github.com/tenderlove/racc"
SRC_URI="https://github.com/tenderlove/racc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc test"

ruby_add_rdepend "virtual/ruby-ssl"

ruby_add_bdepend "dev-ruby/rake
	test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e 's|/tmp/out|${TMPDIR:-/tmp}/out|' test/helper.rb || die "tests fix failed"

	sed -i -e 's/, :isolate//' Rakefile || die
	sed -i -e '/bundler/ s:^:#:' -e '/rdoc/,/^end/ s:^:#:' Rakefile || die

	# Avoid depending on rake-compiler since we don't use it to compile
	# the extension.
	sed -i -e '/rake-compiler/ s:^:#:' -e '/extensiontask/ s:^:#:' Rakefile
	sed -i -e '/ExtensionTask/,/^  end/ s:^:#:' Rakefile
	# Which means we need to generate the parser file here
	rake lib/racc/parser-text.rb || die

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
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
