# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Reference models by URI"
HOMEPAGE="https://github.com/rails/globalid"
SRC_URI="https://github.com/rails/globalid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~amd64-linux"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/activemodel-4.1.0 >=dev-ruby/railties-4.1.0 )"
ruby_add_rdepend ">=dev-ruby/activesupport-4.1.0:*"
