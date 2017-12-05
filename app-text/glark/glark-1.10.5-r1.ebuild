# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="Features.txt History.txt README.md"

inherit ruby-fakegem

DESCRIPTION="File searcher similar to grep but with fancy output"
HOMEPAGE="https://github.com/jpace/glark"

SRC_URI="https://github.com/jpace/glark/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~sparc x86"
IUSE="zip"

ruby_add_rdepend "
	>=dev-ruby/logue-1.0.0
	>=dev-ruby/ragol-1.0.0
	>=dev-ruby/rainbow-2.0.0:2
	>=dev-ruby/riel-1.2.0
	zip? ( dev-ruby/rubyzip:1 )"

ruby_add_bdepend "test? ( dev-ruby/rubyzip:1 )"

all_ruby_prepare() {
	rm -rf doc/ || die

	# Fix broken links to test data.
	sed -i -e 's:/proj/org/incava/glark/::g' $(find test -type f) || die
}
