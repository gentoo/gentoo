# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/GeoRuby/GeoRuby-2.2.1-r2.ebuild,v 1.3 2015/03/13 08:12:27 ago Exp $

EAPI=5

# uses ruby19 hash syntax
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_NAME="georuby"

inherit ruby-fakegem

DESCRIPTION="Ruby data holder for OGC Simple Features"
HOMEPAGE="http://github.com/nofxx/georuby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

ruby_add_rdepend "dev-ruby/dbf
	dev-ruby/nokogiri"
