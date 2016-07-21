# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="This is an extraction of the auto_link method from rails"
HOMEPAGE="https://github.com/tenderlove/rails_autolink"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

ruby_add_rdepend ">=dev-ruby/rails-3.1"
