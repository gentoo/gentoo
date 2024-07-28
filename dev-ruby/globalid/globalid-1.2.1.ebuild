# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="globalid.gemspec"

inherit ruby-fakegem

DESCRIPTION="Reference models by URI"
HOMEPAGE="https://github.com/rails/globalid"
SRC_URI="https://github.com/rails/globalid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/activemodel-6.1 >=dev-ruby/railties-6.1 )"
ruby_add_rdepend ">=dev-ruby/activesupport-6.1:*"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
}
