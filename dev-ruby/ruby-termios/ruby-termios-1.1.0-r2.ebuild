# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md termios.rd"

# There are no tests in the gem, and the upstream tests only work
# with a normal TTY, bug 340575.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A Ruby interface to termios"
HOMEPAGE="http://arika.org/ruby/termios"
LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc x86"
IUSE=""
