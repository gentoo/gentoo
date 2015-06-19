# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/railties/railties-4.0.13.ebuild,v 1.2 2015/03/31 19:22:42 ulm Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test:regular"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="railties.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Tools for creating, working with, and running Rails applications"
HOMEPAGE="http://github.com/rails/rails"
SRC_URI="http://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

# The test suite has many failures, most likely due to a mismatch in
# exact dependencies or environment specifics. Needs further
# investigation.
RESTRICT="test"

RDEPEND+=">=app-eselect/eselect-rails-0.19"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	~dev-ruby/actionpack-${PV}
	>=dev-ruby/thor-0.18.1
	>=dev-ruby/rake-0.8.7"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.13
	)"

all_ruby_prepare() {
	rm "${S}/../Gemfile" || die "Unable to remove Gemfile"
	sed -i -e '/load_paths/d' test/abstract_unit.rb || die "Unable to remove load paths"
	sed -i -e '1igem "minitest", "~>4.0"' test/abstract_unit.rb || die

	# Also allow rdoc 4.x
	sed -i -e 's/~> 3.4/>= 3.4/' ${RUBY_FAKEGEM_GEMSPEC} || die
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
