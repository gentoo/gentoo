# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""

# There are no working tests atm, to be checked on next version bump.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="A comprehensive and flexible logging library written in Ruby"
HOMEPAGE="https://log4r.sourceforge.net/"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 sparc x86"

all_ruby_install() {
	all_fakegem_install

	dodoc -r examples
}
