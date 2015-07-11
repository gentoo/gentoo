# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-vte/ruby-vte-2.2.5.ebuild,v 1.1 2015/07/11 06:14:02 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby vte bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" >=x11-libs/vte-0.12.1:0"
DEPEND+=" >=x11-libs/vte-0.12.1:0"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"
