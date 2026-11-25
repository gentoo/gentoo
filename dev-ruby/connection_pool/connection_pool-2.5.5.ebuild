# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="connection_pool.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="Changes.md README.md"

inherit ruby-fakegem

DESCRIPTION="Generic connection pooling for Ruby"
HOMEPAGE="https://github.com/mperham/connection_pool"
SRC_URI="https://github.com/mperham/connection_pool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/minitest:5 )"

PATCHES=(
	"${FILESDIR}"/connection_pool-2.5.5-ruby40.patch
)

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' connection_pool.gemspec || die
	sed -i -e '/\(bundler\|standard\)/ s:^:#:' Rakefile || die
	sed -i -e "s/gem 'minitest'/gem 'minitest', '~> 5.0'/" test/helper.rb || die

	# Avoid minitest-6, bug #978775
	cat <<-EOF > "${T}/Gemfile" || die
	gem 'rake'
	gem 'minitest', '~> 5'
	EOF
}

each_ruby_test() {
	BUNDLE_GEMFILE="${T}/Gemfile" ${RUBY} -S bundle exec ${RUBY} -S rake test || die
}
