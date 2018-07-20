# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.markdown"

inherit ruby-fakegem

DESCRIPTION="An ultra lite authorization library"
HOMEPAGE="https://github.com/randx/six"
SRC_URI="https://github.com/randx/six/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' spec/spec_helper.rb || die "sed failed"
}
