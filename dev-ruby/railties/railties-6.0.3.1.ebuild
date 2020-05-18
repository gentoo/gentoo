# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

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
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

# The test suite has many failures, most likely due to a mismatch in
# exact dependencies or environment specifics. Needs further
# investigation.
RESTRICT="test"

RDEPEND+=">=app-eselect/eselect-rails-0.24"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	~dev-ruby/actionpack-${PV}
	>=dev-ruby/thor-0.20.3
	>=dev-ruby/rake-0.8.7
	dev-ruby/method_source
"

ruby_add_bdepend "
	test? (
		~dev-ruby/actionview-${PV}
		dev-ruby/mocha:0.14
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
