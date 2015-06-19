# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fattr/fattr-2.2.2.ebuild,v 1.5 2015/01/05 14:55:46 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="fattr.rb is a \"fatter attr\" for ruby"
HOMEPAGE="http://rubyforge.org/projects/codeforpeople/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="test"

each_ruby_test() {
	${RUBY} test/fattr_test.rb || die "Tests failed."
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r samples
}
