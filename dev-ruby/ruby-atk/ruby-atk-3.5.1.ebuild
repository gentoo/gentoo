# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE=""
DEPEND+=" dev-libs/atk[introspection]"
RDEPEND+=" dev-libs/atk[introspection]"

ruby_add_rdepend "~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}"
