# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="XML serialization for your Active Model objects and Active Record models"
HOMEPAGE="https://github.com/rails/activemodel-serializers-xml"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activesupport-5:*
	>=dev-ruby/activemodel-5:*
	=dev-ruby/builder-3*:* >=dev-ruby/builder-3.1:*
"

ruby_add_bdepend "test? (
	>=dev-ruby/activerecord-5:*
	dev-ruby/sqlite3
)"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/datetime.*created_at/ s:^:#:' test/helper.rb || die
}
