# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.markdown"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Easy and customizable generation of forged data"
HOMEPAGE="https://github.com/sevenwire/forgery"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die
}
