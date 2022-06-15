# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31"
RUBY_FAKEGEM_EXTENSIONS="ext/extconf.rb"
RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="An event loop"
HOMEPAGE="https://github.com/socketry/io-event"
SRC_URI="https://github.com/socketry/io-event/archive/68cffe24077a53201acbb383e8e132b192e1fa83.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~sparc"
IUSE=""
RUBY_S="${PN}-68cffe24077a53201acbb383e8e132b192e1fa83"

ruby_add_bdepend "test? ( >=dev-ruby/sus-0.6:0 )"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die
}

each_ruby_test() {
	"${RUBY}" -S sus-parallel || die
}
