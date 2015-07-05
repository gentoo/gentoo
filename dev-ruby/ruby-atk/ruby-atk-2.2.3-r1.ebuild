# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-atk/ruby-atk-2.2.3-r1.ebuild,v 1.1 2015/07/05 10:20:56 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND+=" dev-libs/atk"
RDEPEND+=" dev-libs/atk"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"
