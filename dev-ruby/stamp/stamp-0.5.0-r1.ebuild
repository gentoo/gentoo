# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/stamp/stamp-0.5.0-r1.ebuild,v 1.4 2014/08/02 02:57:03 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="Date and time formatting for humans"
HOMEPAGE="https://github.com/jeremyw/stamp"
SRC_URI="https://github.com/jeremyw/stamp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=""
RDEPEND=""

ruby_add_bdepend "doc? ( dev-ruby/yard dev-ruby/redcarpet )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile || die "sed failed"
	sed -i -e '/bundler/,+7d' features/support/env.rb || die "sed failed"
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc ; then
		yard || die "yard failed"
	fi
}
