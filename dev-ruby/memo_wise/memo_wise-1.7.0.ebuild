# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="memo_wise.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="The wise choice for Ruby memoization"
HOMEPAGE="https://github.com/panorama-ed/memo_wise"
SRC_URI="https://github.com/panorama-ed/memo_wise/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die

	# Avoid specs for an unmaintained package with old dependencies that is optional.
	sed -e '/require.*values/ s:^:#:' \
		-e '/when the class is a Value class/,/^      end/ s:^:#:' \
		-i spec/memo_wise_spec.rb || die

	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
