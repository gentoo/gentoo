# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby cairo-gobject bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="test"

DEPEND="x11-libs/cairo[glib]"
RDEPEND="x11-libs/cairo[glib]"

ruby_add_rdepend "dev-ruby/rcairo
	~dev-ruby/ruby-glib2-${PV}
	test? ( ~dev-ruby/ruby-gobject-introspection-${PV} )"
