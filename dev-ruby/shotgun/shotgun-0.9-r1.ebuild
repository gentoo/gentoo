# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/shotgun/shotgun-0.9-r1.ebuild,v 1.3 2014/10/09 22:18:49 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Forking implementation of rackup"
HOMEPAGE="http://rtomayko.github.com/shotgun/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Warning: the code does not use gem versioning to make sure to load
# only the right rack version so we might need to patch it to work :/
ruby_add_rdepend 'dev-ruby/rack'
ruby_add_bdepend "test? ( dev-ruby/bacon )"

all_ruby_install() {
	all_fakegem_install

	doman man/shotgun.1
}
