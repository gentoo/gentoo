# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby poppler-glib bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

RDEPEND="app-text/poppler[cairo,introspection]"
DEPEND="app-text/poppler[cairo,introspection]"

ruby_add_rdepend "
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-gio2-${PV}
"
