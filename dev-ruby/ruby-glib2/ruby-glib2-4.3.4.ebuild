# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="glib2.gemspec"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
RDEPEND=">=dev-libs/glib-2"
DEPEND=">=dev-libs/glib-2"

all_ruby_prepare() {
	sed -e '/\(native_package_installer\|pkg-config\)/ s:^:#:' \
		-e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	ruby-ng-gnome2_all_ruby_prepare

	# Skip spawn tests since our sandbox also provides items in the
	# environment and this makes the test fragile.
	rm -v test/test-spawn.rb || die
}
