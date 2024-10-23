# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=1 test"

inherit ruby-fakegem

DESCRIPTION="Job framework with pluggable queues"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.3.6
"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha
	)"

all_ruby_prepare() {
	sed -i -e '2igem "activesupport", "~> 6.1.0"' test/helper.rb || die

	# Remove all currently unpackaged queues.
	sed -i -e 's/que queue_classic resque sidekiq sneakers sucker_punch backburner//' \
		-e 's/delayed_job//' Rakefile || die
	sed -i -e '/SneakersAdapter/ s:^:#:' test/cases/exceptions_test.rb || die
}
