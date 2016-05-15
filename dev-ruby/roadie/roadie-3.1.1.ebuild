# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Making HTML emails comfortable for the Rails rockstars"
HOMEPAGE="https://github.com/Mange/roadie"
SRC_URI="https://github.com/Mange/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.5.0
	>=dev-ruby/css_parser-1.3.4"
ruby_add_bdepend "test? ( dev-ruby/rspec-collection_matchers )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
}
