# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC="rerdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A tiny ruby module for Amazon EC2 intance metadata"
HOMEPAGE="https://github.com/bkaney/litc"

IUSE=""
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_bdepend "test? ( dev-ruby/shoulda dev-ruby/fakeweb dev-ruby/minitest:5 )"

all_ruby_prepare() {
	# Don't check dependencies since we provide slightly different packages.
	sed -i -e '/check_dependencies/d'\
		-e 's#rake/rdoctask#rdoc/task#' Rakefile || die
	sed -i -e '/ruby-debug/ s:^:#:' \
		-e '2agem "minitest", "~> 5.0"' test/helper.rb || die
}
