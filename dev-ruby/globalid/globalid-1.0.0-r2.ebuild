# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="globalid.gemspec"

inherit ruby-fakegem

DESCRIPTION="Reference models by URI"
HOMEPAGE="https://github.com/rails/globalid"
SRC_URI="https://github.com/rails/globalid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/activemodel-5.0 >=dev-ruby/railties-5.0 )"
ruby_add_rdepend ">=dev-ruby/activesupport-5.0:*"

all_ruby_prepare() {
	rm -f Gemfile.lock || die

	sed -i -e '2irequire "forwardable"' test/helper.rb || die
}
