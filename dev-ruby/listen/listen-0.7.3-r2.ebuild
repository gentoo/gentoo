# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/listen/listen-0.7.3-r2.ebuild,v 1.3 2015/06/02 05:12:52 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Listens to file modifications and notifies you about the changes"
HOMEPAGE="https://github.com/guard/listen"
SRC_URI="https://github.com/guard/listen/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rb-inotify-0.9.0"

all_ruby_prepare() {
	# Avoid a spec with incorrect stubbing.
	sed -i -e '/loads all the registerd dependencies/,/ end/ s:^:#:' \
		-e '/return true when dependencies are loaded/,/ end/ s:^:#:' \
		spec/listen/dependency_manager_spec.rb || die
}
