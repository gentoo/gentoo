# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="data"

RUBY_FAKEGEM_GEMSPEC="unicode-display_width.gemspec"

inherit ruby-fakegem

DESCRIPTION="Adds String#display_width to get the display size using EastAsianWidth.txt"
HOMEPAGE="https://github.com/janlelis/unicode-display_width"
SRC_URI="https://github.com/janlelis/unicode-display_width/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"

ruby_add_rdepend ">=dev-ruby/unicode-emoji-4.0.4:4"

all_ruby_prepare() {
	# Avoid experimental emoji support for now
	sed -e '/\[emoji\]/,/^  end/ s:^:#:' \
		-e '/Config object based API/,/^end/ s:^:#:' \
		-i spec/display_width_spec.rb || die
}
