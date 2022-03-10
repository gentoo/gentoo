# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

RUBY_FAKEGEM_EXTENSIONS=(ext/fast_xs/extconf.rb ext/fast_xs_extra/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="fast_xs text escaping library ruby bindings"
HOMEPAGE="https://github.com/brianmario/fast_xs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rack )"

PATCHES=( "${FILESDIR}/${P}+ruby-1.9.patch" )

each_ruby_test() {
	# the Rakefile tries to run all the tests in a single process, but
	# this breaks the monkey-patchers, we're forced to run them one by
	# one.
	for tu in test/test_*.rb; do
		${RUBY} -Ilib $tu || die "test $tu failed"
	done
}
