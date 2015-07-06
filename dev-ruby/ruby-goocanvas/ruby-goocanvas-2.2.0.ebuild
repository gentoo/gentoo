# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-goocanvas/ruby-goocanvas-2.2.0.ebuild,v 1.3 2015/07/06 09:38:43 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of GooCanvas"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" x11-libs/goocanvas:2.0"
DEPEND+=" x11-libs/goocanvas:2.0"

ruby_add_bdepend "dev-ruby/pkg-config
	dev-ruby/rcairo"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"
