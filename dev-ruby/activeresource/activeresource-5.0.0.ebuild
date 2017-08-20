# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activeresource.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Think Active Record for web resources"
HOMEPAGE="http://www.rubyonrails.org/"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "=dev-ruby/activesupport-5*:*
	=dev-ruby/activemodel-5*:*
	dev-ruby/activemodel-serializers-xml:1.0
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/test-unit:2
		>=dev-ruby/mocha-0.13.0:0.13
	)"
