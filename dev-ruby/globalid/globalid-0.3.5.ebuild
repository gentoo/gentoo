# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/globalid/globalid-0.3.5.ebuild,v 1.1 2015/04/30 05:17:04 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Reference models by URI"
HOMEPAGE="https://github.com/rails/globalid"
SRC_URI="https://github.com/rails/globalid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/activemodel-4.1.0 >=dev-ruby/railties-4.1.0 )"
ruby_add_rdepend ">=dev-ruby/activesupport-4.1.0:*"
