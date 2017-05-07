# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

RUBY_FAKEGEM_GEMSPEC="rb-inotify.gemspec"

inherit ruby-fakegem

DESCRIPTION="A thorough inotify wrapper for Ruby using FFI"
HOMEPAGE="https://github.com/nex3/rb-inotify"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "virtual/ruby-ffi"

all_ruby_prepare() {
	# Avoid unneeded dependency on jeweler.
	sed -i -e '/:build/ s:^:#:' -e '/module Jeweler/,/^end/ s:^:#:' -e '/class Jeweler/,/^end/ s:^:#:' Rakefile || die

	# Remove mandatory markup processor from yard options, bug 436112.
	sed -i -e '/maruku/d' .yardopts || die
}
