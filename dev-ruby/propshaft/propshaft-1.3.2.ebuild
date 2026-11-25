# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md UPGRADING.md"
RUBY_FAKEGEM_GEMSPEC="propshaft.gemspec"

inherit ruby-fakegem

DESCRIPTION="Deliver assets for Rails"
HOMEPAGE="https://github.com/rails/propshaft"
SRC_URI="https://github.com/rails/propshaft/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

ruby_add_rdepend "
	>=dev-ruby/actionpack-7.0.0:*
	>=dev-ruby/activesupport-7.0.0:*
	dev-ruby/rack:*
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/minitest:6
	dev-ruby/minitest-mock
	>=dev-ruby/rails-7.0.1
)"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	sed -i -e '/debug/ s:^:#:' Gemfile || die

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
