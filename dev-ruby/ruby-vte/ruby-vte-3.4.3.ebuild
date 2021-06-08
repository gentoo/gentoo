# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby vte bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" dev-libs/glib
	x11-libs/gtk+:2
	x11-libs/pango
	>=x11-libs/vte-0.12.1:0"
DEPEND+=" dev-libs/glib
	x11-libs/gtk+:2
	x11-libs/pango
	>=x11-libs/vte-0.12.1:0"

ruby_add_rdepend "~dev-ruby/ruby-gtk2-${PV}"

each_ruby_test() {
	:
}
