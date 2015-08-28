# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# Documentation can be generated using rocco but that is not available
# yet.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Backport require_relative from ruby 1.9.2"
HOMEPAGE="https://steveklabnik.github.com/require_relative"

LICENSE="|| ( Ruby BSD WTFPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-4.7:0 )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile test/require_relative_test.rb || die
	sed -i -e '1igem "minitest", "~> 4.7"' test/require_relative_test.rb || die
}
