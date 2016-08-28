# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md History.markdown"

inherit ruby-fakegem

DESCRIPTION="Liquid tag for displaying GitHub Gists in Jekyll sites"
HOMEPAGE="https://github.com/jekyll/jekyll-gist"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/octokit-4.2"
ruby_add_bdepend "test? ( dev-ruby/webmock
	>=www-apps/jekyll-2 )"

all_ruby_prepare() {
	rm Rakefile || die
}
