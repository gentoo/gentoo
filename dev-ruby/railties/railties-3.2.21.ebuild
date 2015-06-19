# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/railties/railties-3.2.21.ebuild,v 1.2 2015/03/31 19:22:42 ulm Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST="test:regular"
RUBY_FAKEGEM_TASK_DOC="generate_guides"
RUBY_FAKEGEM_DOCDIR="guides/output"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="railties.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Tools for creating, working with, and running Rails applications"
HOMEPAGE="http://github.com/rails/rails"
SRC_URI="http://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

# The test suite has many failures, most likely due to a mismatch in
# exact dependencies or environment specifics. Needs further
# investigation.
RESTRICT="test"

RDEPEND+=">=app-eselect/eselect-rails-0.18"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	~dev-ruby/actionpack-${PV}
	>=dev-ruby/rdoc-3.4
	>=dev-ruby/thor-0.14.6
	>=dev-ruby/rack-ssl-1.3.2:1.3
	>=dev-ruby/rake-0.8.7"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.13
	)
	doc? (
		>=dev-ruby/redcloth-4.1.1
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e '/\(uglifier\|system_timer\|sdoc\|w3c_validators\|pg\)/d' ../Gemfile || die

	# Also allow rdoc 4.x
	sed -i -e 's/~> 3.4/>= 3.4/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	all_fakegem_install

	if use doc ; then
		mv guides/output guides/guides || die
		dohtml -r guides/guides
	fi

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
