# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/msgpack/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/msgpack"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_S="${PN}-ruby-${PV}"
inherit ruby-fakegem

DESCRIPTION="Binary-based efficient data interchange format for ruby binding"
HOMEPAGE="https://msgpack.org/"
# In 1.6.1, they stopped shipping the specs in the gem :(
# https://github.com/msgpack/msgpack-ruby/commit/9cbcd0b28527af5ca755f34dfb370e3f4474d129 (https://github.com/msgpack/msgpack-ruby/pull/311)
SRC_URI="https://github.com/msgpack/msgpack-ruby/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~sparc ~x86"
IUSE="doc"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# Remove jruby-specific specs that are run also for other rubies.
	rm -rf spec/jruby || die

	sed -i -e 's/git ls-files/find * -print/' msgpack.gemspec || die
}
