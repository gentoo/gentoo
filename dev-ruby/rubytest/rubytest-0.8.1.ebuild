# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubytest/rubytest-0.8.1.ebuild,v 1.6 2015/04/27 06:16:26 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby Test is a universal test harness for Ruby"
HOMEPAGE="https://rubyworks.github.io/rubytest/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/ae dev-ruby/qed )"
ruby_add_rdepend "dev-ruby/ansi"

each_ruby_test() {
	${RUBY} -S qed || die 'tests failed'
}
