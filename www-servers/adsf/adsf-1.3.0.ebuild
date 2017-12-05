# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="ChangeLog NEWS.md README.md"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="A Dead Simple Fileserver is a static file server that can launch in a directory"
HOMEPAGE="http://nanoc.stoneship.org/"
SRC_URI="https://github.com/ddfreyne/adsf/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rack-1.0.0:*"

ruby_add_bdepend "test? ( dev-ruby/rack-test )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^)/ s:^:#:' test/helper.rb || die
	sed -i -e '/rubocop/I s:^:#:' Rakefile || die
}
