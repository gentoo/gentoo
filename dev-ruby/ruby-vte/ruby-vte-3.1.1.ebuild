# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby vte bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" >=x11-libs/vte-0.12.1:0"
DEPEND+=" >=x11-libs/vte-0.12.1:0"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"
