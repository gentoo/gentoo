# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Utility-belt to build form data request bodies"
HOMEPAGE="https://github.com/httprb/form_data.rb"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.start/ s:^:#:' spec/spec_helper.rb || die
}
