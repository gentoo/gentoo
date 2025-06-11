# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="track_open_instances.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A mixin to track instances of Ruby classes that require explicit cleanup"
HOMEPAGE="https://github.com/main-branch/track_open_instances"
SRC_URI="https://github.com/main-branch/track_open_instances/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~x86"

all_ruby_prepare() {
	sed -e '/simplecov/ s:^:#:' \
		-e '/SimpleCov::RSpec/ s:^:#:' \
		-i spec/spec_helper.rb || die

	sed -e "s/__dir__/'.'/" \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
