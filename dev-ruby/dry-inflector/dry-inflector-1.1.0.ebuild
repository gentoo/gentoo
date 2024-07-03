# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="dry-inflector.gemspec"

inherit ruby-fakegem

DESCRIPTION="String inflections for dry-rb"

HOMEPAGE="https://dry-rb.org/gems/dry-inflector/"
SRC_URI="https://github.com/dry-rb/dry-inflector/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/warning )"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|coverage\)/ s/^/#/' spec/spec_helper.rb || die
}
