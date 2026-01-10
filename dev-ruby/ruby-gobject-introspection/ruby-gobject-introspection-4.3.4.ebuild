# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="gobject-introspection.gemspec"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby GObjectIntrospection bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

DEPEND="dev-libs/glib
	dev-libs/gobject-introspection"
RDEPEND="dev-libs/glib
	dev-libs/gobject-introspection"

ruby_add_rdepend "~dev-ruby/ruby-glib2-${PV}"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	ruby-ng-gnome2_all_ruby_prepare
}
