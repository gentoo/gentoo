# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.rdoc README.ja.rdoc TODO ChangeLog"

RUBY_FAKEGEM_GEMSPEC="racc.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/racc/cparse/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/racc/cparse"

inherit ruby-fakegem

DESCRIPTION="A LALR(1) parser generator for Ruby"
HOMEPAGE="https://github.com/tenderlove/racc"
SRC_URI="https://github.com/tenderlove/racc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"

ruby_add_rdepend "virtual/ruby-ssl"

ruby_add_bdepend "dev-ruby/rake
	test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e 's/, :isolate//' Rakefile || die
	sed -i -e '/bundler/ s:^:#:' -e '/rdoc/,/^end/ s:^:#:' Rakefile || die

	# Avoid depending on rake-compiler since we don't use it to compile
	# the extension.
	sed -i -e '/rake-compiler/ s:^:#:' -e '/extensiontask/ s:^:#:' Rakefile || die
	sed -i -e '/ExtensionTask/,/^  end/ s:^:#:' Rakefile || die

	# ...which means we need to generate the parser file here
	for ruby in $(ruby_get_use_implementations) ; do
		if has_version -b "virtual/rubygems[ruby_targets_${ruby}(-)]" &&
		   has_version -b "dev-ruby/rake[ruby_targets_${ruby}(-)]" ; then
			${ruby} -S rake lib/racc/parser-text.rb || die
			break
		fi
	done

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r doc

	docinto examples
	dodoc -r sample
}
