# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTENSIONS=(ext/kissfft/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="ruby interface to kissfft"
HOMEPAGE="https://rubygems.org/gems/kissfft"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

each_ruby_perpare() {
	mkdir lib || die
}
