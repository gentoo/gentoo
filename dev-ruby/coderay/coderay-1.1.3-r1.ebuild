# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

# The test target also contains test:exe but that requires
# shoulda-context which we do not have packaged yet.
RUBY_FAKEGEM_TASK_TEST="spec test:functional test:units"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="Changes-pre-1.0.textile Changes.textile FOLDERS README_INDEX.rdoc README.markdown"

RUBY_FAKEGEM_GEMSPEC="coderay.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Ruby library for syntax highlighting"
HOMEPAGE="http://coderay.rubychan.de/"
SRC_URI="https://github.com/rubychan/coderay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

PATCHES=("${FILESDIR}/${P}-ruby30.patch")

# Redcloth is an optional but automagically tested dependency. This
# requires redcloth-4.2.2. We don't depend on this version to make
# bootstrapping rspec with new versions easier, since redcloth depends
# on rake-compiler.

ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e '/git ls-files/ s:^:#:' -e 's/.rc.*"/"/' coderay.gemspec || die

	# Fix failing tests for lazy evaluation in ruby26
	sed -i -e 's/\.filter$/.filter.to_a/' test/unit/filter.rb || die
}
