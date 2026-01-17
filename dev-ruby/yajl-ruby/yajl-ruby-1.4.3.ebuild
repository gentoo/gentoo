# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTENSIONS=(ext/yajl/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/yajl"

inherit ruby-fakegem

DESCRIPTION="Ruby C bindings to the Yajl JSON stream-based parser library"
HOMEPAGE="https://github.com/brianmario/yajl-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="${RDEPEND} dev-libs/yajl"
DEPEND="${DEPEND} dev-libs/yajl"

each_ruby_prepare() {
	# Make sure the right ruby interpreter is used
	sed -e '/capture/ s:ruby:'${RUBY}':' -i spec/parsing/large_number_spec.rb || die
}

each_ruby_test() {
	# Set RUBYLIB to pass search path on to additional interpreters that
	# are started.
	RUBYLIB=lib RSPEC_VERSION=3 ruby-ng_rspec || die
}
