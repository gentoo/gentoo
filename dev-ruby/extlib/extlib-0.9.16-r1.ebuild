# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/extlib/extlib-0.9.16-r1.ebuild,v 1.4 2014/11/01 09:26:59 graaff Exp $

EAPI=5

# ruby21 → fails specs.
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_DOC="-f tasks/yard.rake yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_GEMSPEC=${PN}.gemspec

inherit ruby-fakegem

DESCRIPTION="Support library for DataMapper and Merb"
HOMEPAGE="http://extlib.rubyforge.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? ( >=dev-ruby/json-1.4.0 )"

all_ruby_prepare() {
	sed -i -e '/spec/d' spec/spec_helper.rb || die

	# We always use json.
	sed -i -e 's/json_pure/json/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
