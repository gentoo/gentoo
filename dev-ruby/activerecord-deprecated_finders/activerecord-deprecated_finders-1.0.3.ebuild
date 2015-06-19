# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activerecord-deprecated_finders/activerecord-deprecated_finders-1.0.3.ebuild,v 1.7 2014/12/27 17:30:27 graaff Exp $

EAPI=4
USE_RUBY="ruby19 ruby20 ruby21"

# this is not null so that the dependencies will actually be filled
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem versionator

DESCRIPTION="This gem will be used to extract and deprecate old-style finder option hashes in Active Record"
HOMEPAGE="https://github.com/rails"
SLOT="$(get_version_component_range 1-2)"

LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/activerecord:4.0
	>=dev-ruby/minitest-3
	>=dev-ruby/sqlite3-1.3 )"

all_ruby_prepare() {
	# The code is only compatible with Rails 4.0.
	sed -i -e 's/< 5/< 4.1/' Gemfile || die
}
