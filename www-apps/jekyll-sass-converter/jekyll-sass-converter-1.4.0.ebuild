# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md History.markdown"

inherit ruby-fakegem

DESCRIPTION="A basic Sass converter for Jekyll"
HOMEPAGE="https://github.com/jekyll/jekyll-sass-converter"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/sass:3.4"
ruby_add_bdepend "test? ( >=www-apps/jekyll-2 )"
