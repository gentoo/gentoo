# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt README.md"

inherit ruby-fakegem eutils

DESCRIPTION="Adds a streamy multipart form post capability to Net::HTTP"
HOMEPAGE="https://github.com/nicksieger/multipart-post"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
