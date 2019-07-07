# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A thorough inotify wrapper for Ruby using FFI"
HOMEPAGE="https://github.com/nex3/rb-inotify"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ppc ppc64 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/ffi"

ruby_add_bdepend "test? ( dev-ruby/concurrent-ruby )"

all_ruby_prepare() {
	# Avoid unneeded dependency on jeweler.
	sed -i -e '/:build/ s:^:#:' -e '/module Jeweler/,/^end/ s:^:#:' -e '/class Jeweler/,/^end/ s:^:#:' Rakefile || die

	# Remove mandatory markup processor from yard options, bug 436112.
	sed -i -e '/maruku/d' .yardopts || die

	sed -i -e '/bundler/ s:^:#:' -e '1irequire "pathname"' spec/spec_helper.rb || die
}
