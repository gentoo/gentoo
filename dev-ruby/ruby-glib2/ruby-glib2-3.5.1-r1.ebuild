# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Glib2 bindings"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE=""
RDEPEND+=" >=dev-libs/glib-2"
DEPEND+=" >=dev-libs/glib-2"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5.1-glib-2.76.patch
)

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Skip spawn tests since our sandbox also provides items in the
	# environment and this makes the test fragile.
	rm -v test/test-spawn.rb || die
}
