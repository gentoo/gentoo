# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/listen/listen-2.8.6.ebuild,v 1.1 2015/03/18 13:10:28 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/guard/listen/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Listens to file modifications and notifies you about the changes"
HOMEPAGE="https://github.com/guard/listen"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64"
IUSE=""

# Block on other packages trying to install a /usr/bin/listen
RDEPEND+="!!media-sound/listen !!media-radio/ax25"

ruby_add_rdepend ">=dev-ruby/rb-inotify-0.9.0
	>=dev-ruby/celluloid-0.15.2"
ruby_add_bdepend "test? ( dev-ruby/celluloid-io )"

all_ruby_prepare() {
	sed -i -e "/git/,+3d" -e "/rb-fsevent/d" -e "/bundler/d" -e "/rspec-retry/d" ${PN}.gemspec || die
	sed -i -e "/retry/d"  spec/spec_helper.rb || die
	rm -rf spec/lib/listen/adapter/darwin_spec.rb || die
}
