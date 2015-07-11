# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/http-form_data/http-form_data-1.0.1.ebuild,v 1.3 2015/07/11 20:18:40 zlogene Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Utility-belt to build form data request bodies"
HOMEPAGE="https://github.com/httprb/form_data.rb"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.start/ s:^:#:' spec/spec_helper.rb || die
}
