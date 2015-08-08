# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# this is not null so that the dependencies will actually be filled
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem versionator

DESCRIPTION="This gem will be used to extract and deprecate old-style finder option hashes in Active Record"
HOMEPAGE="https://github.com/rails"
SRC_URI="https://github.com/rails/activerecord-deprecated_finders/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="$(get_version_component_range 1-2)"

LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/bundler
	=dev-ruby/activerecord-4*
	>=dev-ruby/minitest-3
	>=dev-ruby/sqlite3-1.3 )"
