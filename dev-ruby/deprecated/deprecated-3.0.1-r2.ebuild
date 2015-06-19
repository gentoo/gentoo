# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/deprecated/deprecated-3.0.1-r2.ebuild,v 1.1 2015/03/04 15:55:30 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="A Ruby library for handling deprecated code"
HOMEPAGE="https://github.com/erikh/deprecated"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	${RUBY} -Ilib:. test/test_deprecated.rb || die "test failed"
}
