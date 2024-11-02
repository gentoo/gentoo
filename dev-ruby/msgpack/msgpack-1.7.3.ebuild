# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/msgpack/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/msgpack"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Binary-based efficient data interchange format for ruby binding"
HOMEPAGE="https://msgpack.org/"
SRC_URI="https://github.com/msgpack/msgpack-ruby/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc ~x86"
IUSE="doc"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# Remove jruby-specific specs that are run also for other rubies.
	rm -rf spec/jruby || die

	sed -i -e 's/git ls-files -z/find * -print0/' msgpack.gemspec || die
}
