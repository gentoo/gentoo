# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

inherit multilib ruby-fakegem

DESCRIPTION="Ruby C bindings to the Yajl JSON stream-based parser library"
HOMEPAGE="https://github.com/brianmario/yajl-ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="${RDEPEND} dev-libs/yajl"
DEPEND="${DEPEND} dev-libs/yajl"

each_ruby_prepare() {
	# Make sure the right ruby interpreter is used
	sed -e '/capture/ s:ruby:'${RUBY}':' -i spec/parsing/large_number_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/yajl extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/yajl CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" V=1
	cp ext/yajl/yajl$(get_modname) lib/yajl/ || die
}

each_ruby_test() {
	# Set RUBYLIB to pass search path on to additional interpreters that
	# are started.
	RUBYLIB=lib RSPEC_VERSION=3 ruby-ng_rspec || die
}
