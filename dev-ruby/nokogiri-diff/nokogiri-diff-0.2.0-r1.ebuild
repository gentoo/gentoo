# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/nokogiri-diff/nokogiri-diff-0.2.0-r1.ebuild,v 1.4 2015/04/19 18:41:39 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README.md"

inherit ruby-fakegem

DESCRIPTION="Calculate the differences (added or removed nodes) between two XML/HTML documents"
HOMEPAGE="https://github.com/postmodern/nokogiri-diff"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5 >=dev-ruby/tdiff-0.3.2"
