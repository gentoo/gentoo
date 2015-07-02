# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/arel/arel-3.0.3.ebuild,v 1.1 2015/07/02 05:17:51 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.markdown"

# Generating the gemspec from metadata causes a crash in jruby
RUBY_FAKEGEM_GEMSPEC="arel.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Arel is a Relational Algebra for Ruby"
HOMEPAGE="http://github.com/rails/arel"
LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? ( >=dev-ruby/hoe-2.10 )
	test? (
		>=dev-ruby/hoe-2.10
		virtual/ruby-minitest
	)"

all_ruby_prepare() {
	# Put the proper version number in the gemspec.
	sed -i -e "s/ s.version = \".*\"/ s.version = \"${PV}\"/" arel.gemspec || die
}
