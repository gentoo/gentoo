# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple mime type detection using magic numbers, filenames, and extensions"
HOMEPAGE="https://github.com/basecamp/marcel"
SRC_URI="https://github.com/basecamp/marcel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/mimemagic-0.3.2:0"

ruby_add_bdepend "test? ( dev-ruby/rack )"

all_ruby_prepare() {
	sed -i -e '2irequire "pathname"' test/test_helper.rb || die

	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	# Account for changes in shared-mime-info 1.10
	mkdir test/fixtures/{magic,name}/font || die
	mv test/fixtures/magic/application/x-font-ttf.ttf test/fixtures/magic/font/ttf.ttf || die
	mv test/fixtures/name/application/x-font-ttf.ttf test/fixtures/name/font/ttf.ttf || die
}
