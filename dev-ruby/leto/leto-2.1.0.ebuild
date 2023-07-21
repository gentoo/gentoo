# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="leto.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Generic object traverser for Ruby"
HOMEPAGE="https://github.com/jaynetics/leto"
SRC_URI="https://github.com/jaynetics/leto/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc"
IUSE=""

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/git ls-files -z/find * -print0/' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}
