# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Skip spawn tests since our sandbox also provides items in the
	# environment and this makes the test fragile.
	rm -v test/test-spawn.rb || die
}
