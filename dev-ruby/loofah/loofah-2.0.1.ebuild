# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/loofah/loofah-2.0.1.ebuild,v 1.5 2015/03/22 16:30:24 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A general library for manipulating and transforming HTML/XML documents and fragments."
HOMEPAGE="https://github.com/flavorjones/loofah"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5.9"

ruby_add_bdepend "test? ( >=dev-ruby/rr-1.1.0 >=dev-ruby/hoe-2.3.0 )"

all_ruby_prepare() {
	# Avoid test failing on different whitespace.
	sed -i -e '/test_fragment_whitewash_on_microsofty_markup/askip "gentoo"' test/integration/test_ad_hoc.rb || die
}
