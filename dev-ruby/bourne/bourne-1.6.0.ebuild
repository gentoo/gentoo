# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_TEST="MOCHA_OPTIONS=use_test_unit_gem test:units test:acceptance"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Extends mocha to allow tracking and querying of stub and mock invocations"
HOMEPAGE="https://github.com/thoughtbot/bourne"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/mocha-1.1:1.0"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' "${RUBY_FAKEGEM_GEMSPEC}" || die
	sed -i -e '/bundler/d' Rakefile || die
}
