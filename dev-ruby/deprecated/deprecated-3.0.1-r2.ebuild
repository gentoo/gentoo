# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A Ruby library for handling deprecated code"
HOMEPAGE="https://github.com/erikh/deprecated"

LICENSE="BSD"
SLOT="3"
KEYWORDS="amd64 ppc x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	${RUBY} -Ilib:. test/test_deprecated.rb || die "test failed"
}
