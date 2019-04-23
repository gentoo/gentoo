# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby vte bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" >=x11-libs/vte-0.12.1:0"
DEPEND+=" >=x11-libs/vte-0.12.1:0"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"

all_ruby_prepare() {
	# Avoid native installer
	sed -i -e '/native-package-installer/ s:^:#: ; /^\s*setup_homebrew_libffi/ s:^:#:' ../glib2/lib/mkmf-gnome2.rb || die
}
