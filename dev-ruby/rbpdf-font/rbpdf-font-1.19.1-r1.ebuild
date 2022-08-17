# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This gem bundles dejavu fonts, freefonts, and ttf2ufm
# ttf2ufm is a precompiled 32-bit binary

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG"

inherit ruby-fakegem

DESCRIPTION="Font files for the Ruby on Rails RBPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend ">=dev-ruby/test-unit-3:2"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile || die
	sed -i -e '2igem "test-unit", "~>3.0"' test/test_helper.rb || die
}
