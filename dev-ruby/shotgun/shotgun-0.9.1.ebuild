# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="Forking implementation of rackup"
HOMEPAGE="https://github.com/rtomayko/shotgun"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Warning: the code does not use gem versioning to make sure to load
# only the right rack version so we might need to patch it to work :/
ruby_add_rdepend 'dev-ruby/rack'
ruby_add_bdepend "test? ( dev-ruby/bacon )"

each_ruby_test() {
	${RUBY} -Ilib test/test_shotgun_static.rb || die
	${RUBY} -Ilib test/test_shotgun_loader.rb || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/shotgun.1
}
