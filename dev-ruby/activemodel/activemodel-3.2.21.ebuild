# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activemodel/activemodel-3.2.21.ebuild,v 1.1 2014/11/17 20:17:36 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activemodel.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="A toolkit for building modeling frameworks like Active Record and Active Resource"
HOMEPAGE="http://github.com/rails/rails"
SRC_URI="http://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/builder-3.0.0:3
	>=dev-ruby/bcrypt-ruby-3.0.0"

ruby_add_bdepend "
	test? (
		>=dev-ruby/mocha-0.13.0:0.13
	)"

all_ruby_prepare() {
	# Set test environment to our hand.
	rm "${S}/../Gemfile" || die "Unable to remove Gemfile"
	sed -i -e '/load_paths/d' test/cases/helper.rb || die "Unable to remove load paths"

	# Fix bcrypt dependency since bcrypt uses semantic versioning.
	sed -i -e '/bcrypt-ruby/ s/3.0.0/3.0/' lib/active_model/secure_password.rb || die
}
