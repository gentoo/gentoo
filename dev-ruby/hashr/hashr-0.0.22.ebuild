# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hashr/hashr-0.0.22.ebuild,v 1.3 2015/05/17 09:45:07 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Simple Hash extension to make working with nested hashes easier and less error-prone"
HOMEPAGE="https://github.com/svenfuchs/hashr"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test_declarative )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' test/test_helper.rb || die
}
