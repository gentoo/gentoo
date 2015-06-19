# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/cri/cri-2.6.1.ebuild,v 1.2 2014/10/30 13:41:47 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="-Ilib test"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.adoc"

RUBY_FAKEGEM_TASK_DOC="doc"

inherit ruby-fakegem

DESCRIPTION="Cri is a library for building easy-to-use commandline tools"
HOMEPAGE="http://rubygems.org/gems/cri"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/colored-1.2"

ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/yard dev-ruby/minitest )"

all_ruby_prepare() {
	sed -e '/coveralls/I s:^:#:' -i test/helper.rb || die
}
