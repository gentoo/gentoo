# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ruby22, ruby23: fails due to minitest incompatabilities.
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Simply adds a declarative test method syntax to test/unit"
HOMEPAGE="https://github.com/svenfuchs/test_declarative"
SRC_URI="https://github.com/svenfuchs/test_declarative/tarball/v${PV} -> ${P}.tgz"
RUBY_S="svenfuchs-test_declarative-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/minitest:5 )"

all_ruby_prepare() {
	sed -i -e '/rake/ s/12.0.0/12/' Gemfile || die
}

each_ruby_test() {
	# There are other gemfiles but their setup seems broken atm.
	for gemfile in Gemfile ; do
		einfo "Running tests with ${gemfile}"
		BUNDLE_GEMFILE=${gemfile} ${RUBY} -S bundle exec rake test || die
	done
}
