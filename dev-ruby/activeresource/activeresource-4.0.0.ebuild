# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activeresource.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Think Active Record for web resources"
HOMEPAGE="http://rubyforge.org/projects/activeresource/"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

#RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "=dev-ruby/activesupport-4*
	=dev-ruby/activemodel-4*
	>=dev-ruby/rails-observers-0.1.1:0.1"

ruby_add_bdepend "
	test? (
		dev-ruby/test-unit:2
		>=dev-ruby/mocha-0.13.0:0.13
	)"

all_ruby_prepare() {
	# Set test environment to our hand.
	rm Gemfile || die "Unable to remove Gemfile"

	# Pull in the correct version of minitest since we don't use bundler.
	sed -i -e '1igem "minitest", "~>4.0"' \
		-e '2igem "activemodel", "~>4.0.0"' test/abstract_unit.rb || die

}
