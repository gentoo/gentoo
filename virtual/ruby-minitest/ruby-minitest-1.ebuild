# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22"

inherit ruby-ng

DESCRIPTION="Virtual ebuild for the Ruby minitest library"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"

RDEPEND="
	ruby_targets_ruby21? ( || ( dev-ruby/minitest[ruby_targets_ruby21] dev-lang/ruby:2.1 ) )
	ruby_targets_ruby22? ( || ( dev-ruby/minitest[ruby_targets_ruby22] dev-lang/ruby:2.2 ) )"
