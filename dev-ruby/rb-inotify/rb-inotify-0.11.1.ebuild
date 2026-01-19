# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="rb-inotify.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A thorough inotify wrapper for Ruby using FFI"
HOMEPAGE="https://github.com/guard/rb-inotify"
SRC_URI="https://github.com/guard/rb-inotify/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend "dev-ruby/ffi:0"

ruby_add_bdepend "test? ( dev-ruby/concurrent-ruby )"

all_ruby_prepare() {
	sed -e "s:_relative ': './:" \
		-e 's/git ls-files/find * -print/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove mandatory markup processor from yard options, bug 436112.
	sed -i -e '/maruku/d' .yardopts || die

	sed -i -e '/bundler/ s:^:#:' -e '1irequire "pathname"' spec/spec_helper.rb || die
}
