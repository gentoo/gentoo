# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby wrapper for UglifyJS JavaScript compressor"
HOMEPAGE="https://github.com/lautis/uglifier"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux"

IUSE="test"

ruby_add_rdepend ">=dev-ruby/execjs-0.3.0:* >=dev-ruby/json-1.8.0"

ruby_add_bdepend "test? ( dev-ruby/source_map )"
