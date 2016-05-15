# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Provides patch-level verification for Bundled apps"
HOMEPAGE="https://github.com/rubysec/bundler-audit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

#tests are trying to download AND have some odd failures
#rspec ./spec/database_spec.rb:113 # Bundler::Audit::Database#size should eq 323
#rspec ./spec/database_spec.rb:117 # Bundler::Audit::Database#advisories should return a list of all advisories.
RESTRICT=test

ruby_add_rdepend "
	>=dev-ruby/thor-0.18:0
	>=dev-ruby/bundler-1.2:0
"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die

	# Avoid specs that require network access via 'bundle install'
	rm spec/{integration,scanner}_spec.rb || die

	# Avoid specs that only work when the source is a git repository
	sed -i -e '/describe "path"/,/^  end/ s:^:#:' \
		-e '/describe "update!"/,/^  end/ s:^:#:' \
		spec/database_spec.rb || die
}
