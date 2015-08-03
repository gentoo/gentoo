# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/listen/listen-1.3.1-r2.ebuild,v 1.7 2015/08/03 13:47:45 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Listens to file modifications and notifies you about the changes"
HOMEPAGE="https://github.com/guard/listen"
SRC_URI="https://github.com/guard/listen/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x64-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rb-inotify-0.9.0"

all_ruby_prepare() {
	sed -i -e '/[Cc]overalls/d' spec/spec_helper.rb || die
	# Drop failing test
	sed -i -e '/#85/,+17d' spec/listen/directory_record_spec.rb || die

	# Drop dependencies for file system events not available on Gentoo.
	sed -i -e '/\(fsevent\|kqueue\)/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
