# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby cairo-gobject bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE=""

DEPEND+=" x11-libs/cairo"
RDEPEND+=" x11-libs/cairo"

ruby_add_rdepend "dev-ruby/rcairo
	~dev-ruby/ruby-glib2-${PV}"
