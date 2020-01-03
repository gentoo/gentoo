# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

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
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/minitest-5.10:5 )"

all_ruby_prepare() {
	sed -i -e '/rake/ s/~> 12.0.0/>= 10/ ; /minitest/ s/5.10.1/5.10/' Gemfile || die
}

each_ruby_test() {
	# There are other gemfiles but their setup seems broken atm.
	for gemfile in Gemfile ; do
		einfo "Running tests with ${gemfile}"
		BUNDLE_GEMFILE=${gemfile} ${RUBY} -S bundle exec rake test || die
	done
}
