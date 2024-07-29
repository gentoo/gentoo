# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTENSIONS=(ext/curses/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby binding for curses, ncurses, and PDCurses"
HOMEPAGE="https://github.com/ruby/curses"
LICENSE="|| ( Ruby BSD-2 )"

SLOT="1"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND+=" sys-libs/ncurses:0"
RDEPEND+=" sys-libs/ncurses:0"

each_ruby_test() {
	# No specs so we use the smoketest that upstream use in CI:
	# https://github.com/ruby/curses/blob/master/.github/workflows/ubuntu.yml#L26
	${RUBY} -Ilib:ext/curses:. -r curses -e 'puts Curses::VERSION' || die
}
