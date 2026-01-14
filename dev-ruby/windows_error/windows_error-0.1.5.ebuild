# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="reference for standard Windows API Error Codes"
HOMEPAGE="https://github.com/rapid7/windows_error"

LICENSE="BSD"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	rm -f .rspec || die
}
