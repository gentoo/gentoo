# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md History.markdown"

RUBY_FAKEGEM_GEMSPEC="jekyll-sitemap.gemspec"

inherit ruby-fakegem

DESCRIPTION="Automatically generate a sitemap.xml for your Jekyll site"
HOMEPAGE="https://github.com/jekyll/jekyll-sitemap"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "=www-apps/jekyll-4*"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find -type f -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
