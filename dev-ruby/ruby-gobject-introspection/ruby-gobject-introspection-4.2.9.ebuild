# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby GObjectIntrospection bindings"
KEYWORDS="amd64 ~ppc ~riscv ~x86"

DEPEND="dev-libs/glib
	dev-libs/gobject-introspection"
RDEPEND="dev-libs/glib
	dev-libs/gobject-introspection"

ruby_add_rdepend "~dev-ruby/ruby-glib2-${PV}"
