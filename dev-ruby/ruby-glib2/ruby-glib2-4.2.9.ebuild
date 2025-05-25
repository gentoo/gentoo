# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"
RDEPEND=">=dev-libs/glib-2"
DEPEND=">=dev-libs/glib-2"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Skip spawn tests since our sandbox also provides items in the
	# environment and this makes the test fragile.
	rm -v test/test-spawn.rb || die
}
