# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_GEMSPEC="magic.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

SRC_URI="https://github.com/qoobaa/magic/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Ruby FFI bindings to libmagic"
HOMEPAGE="https://github.com/qoobaa/magic"

IUSE="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="sys-apps/file"
DEPEND+="test? ( sys-apps/file )"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
ruby_add_rdepend "dev-ruby/ffi"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Fix File.exists? deprecation
	sed -i -e 's/File.exists?/File.exist?/' lib/magic/database.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib -Itest test/test_magic.rb || die
}
