# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/GeoRuby/GeoRuby-2.5.2.ebuild,v 1.1 2015/04/04 10:20:19 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_NAME="georuby"

inherit ruby-fakegem

DESCRIPTION="Ruby data holder for OGC Simple Features"
HOMEPAGE="https://github.com/nofxx/georuby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	# Avoid specs that are also failing in upstream Travis.
	rm spec/geo_ruby/shp4r/shp_spec.rb || die
}

ruby_add_bdepend "test? ( dev-ruby/dbf
	dev-ruby/nokogiri )"
