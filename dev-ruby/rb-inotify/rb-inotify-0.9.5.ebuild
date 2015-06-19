# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rb-inotify/rb-inotify-0.9.5.ebuild,v 1.6 2014/12/31 11:28:04 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC="yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

RUBY_FAKEGEM_GEMSPEC="rb-inotify.gemspec"

inherit ruby-fakegem

DESCRIPTION="A thorough inotify wrapper for Ruby using FFI"
HOMEPAGE="https://github.com/nex3/rb-inotify"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x64-macos"
IUSE=""

ruby_add_rdepend "virtual/ruby-ffi"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	# Avoid unneeded dependency on jeweler.
	sed -i -e '/:build/ s:^:#:' -e '/module Jeweler/,/^end/ s:^:#:' -e '/class Jeweler/,/^end/ s:^:#:' Rakefile || die

	# Remove mandatory markup processor from yard options, bug 436112.
	sed -i -e '/maruku/d' .yardopts || die
}
