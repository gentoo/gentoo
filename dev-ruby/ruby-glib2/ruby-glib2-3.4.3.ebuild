# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Skip spawn tests since our sandbox also provides items in the
	# environment and this makes the test fragile.
	rm -v test/test-spawn.rb || die
}
