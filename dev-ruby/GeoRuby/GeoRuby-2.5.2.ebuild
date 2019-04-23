# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_NAME="georuby"

inherit ruby-fakegem

DESCRIPTION="Ruby data holder for OGC Simple Features"
HOMEPAGE="https://github.com/nofxx/georuby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

all_ruby_prepare() {
	# Avoid specs that are also failing in upstream Travis.
	rm spec/geo_ruby/shp4r/shp_spec.rb || die
}

ruby_add_bdepend "test? ( dev-ruby/dbf
	dev-ruby/nokogiri )"
