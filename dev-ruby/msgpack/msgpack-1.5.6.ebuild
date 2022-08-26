# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/msgpack/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/msgpack"

inherit ruby-fakegem

DESCRIPTION="Binary-based efficient data interchange format for ruby binding"
HOMEPAGE="https://msgpack.org/"

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
