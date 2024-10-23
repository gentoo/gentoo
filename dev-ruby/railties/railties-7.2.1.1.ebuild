# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST="test:regular"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="railties.gemspec"

RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Tools for creating, working with, and running Rails applications"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

# The test suite has many failures, most likely due to a mismatch in
# exact dependencies or environment specifics. Needs further
# investigation.
RESTRICT="test"

RDEPEND=">=app-eselect/eselect-rails-0.28"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	~dev-ruby/activesupport-${PV}
	dev-ruby/irb
	>=dev-ruby/rackup-1.0.0
	>=dev-ruby/rake-12.2
	>=dev-ruby/thor-1.2.2:1
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "
	test? (
		~dev-ruby/actionview-${PV}
		dev-ruby/mocha
	)"

all_ruby_prepare() {
	rm "${S}/../Gemfile" || die "Unable to remove Gemfile"
	sed -i -e '/load_paths/d' test/abstract_unit.rb || die "Unable to remove load paths"
	sed -i -e '1igem "minitest", "~>4.0"' test/abstract_unit.rb || die
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper rails rails-${PV}
}

pkg_postinst() {
	elog "To select between slots of rails, use:"
	elog "\teselect rails"

	eselect rails update
}

pkg_postrm() {
	eselect rails update
}
