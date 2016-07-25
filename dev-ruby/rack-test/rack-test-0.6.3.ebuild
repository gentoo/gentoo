# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

# no documentation is generable, it needs hanna, which is broken
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit versionator ruby-fakegem

DESCRIPTION="Rack::Test is a small, simple testing API for Rack apps"
HOMEPAGE="https://github.com/brynary/rack-test"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0:*"
ruby_add_bdepend "
	test? ( >=dev-ruby/sinatra-1.2.6 )"

all_ruby_prepare() {
	rm Gemfile* || die
	sed -i -e '/bundler/d' -e '/[Cc]ode[Cc]limate/d' spec/spec_helper.rb || die
}
