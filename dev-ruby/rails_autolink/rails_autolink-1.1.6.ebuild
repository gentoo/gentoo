# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rails_autolink/rails_autolink-1.1.6.ebuild,v 1.2 2014/08/05 16:00:32 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="This is an extraction of the auto_link method from rails"
HOMEPAGE="http://github.com/tenderlove/rails_autolink"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

ruby_add_rdepend ">=dev-ruby/rails-3.1"
