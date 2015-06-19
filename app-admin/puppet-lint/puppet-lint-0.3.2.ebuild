# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/puppet-lint/puppet-lint-0.3.2.ebuild,v 1.3 2014/08/10 01:37:41 patrick Exp $

EAPI="4"
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="README*"
RUBY_FAKEGEM_DOCDIR="html"

inherit eutils ruby-fakegem

DESCRIPTION="A linter for puppet DSL"
HOMEPAGE="http://puppet-lint.com/"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

ruby_add_rdepend "dev-ruby/rake"
