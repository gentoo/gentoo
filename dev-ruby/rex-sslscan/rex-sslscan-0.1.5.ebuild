# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="ruby implmenetation of the SSLScan tool "
HOMEPAGE="https://rubygems.org/gems/rex-sslscan"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

PDEPEND="dev-libs/openssl"

ruby_add_rdepend "dev-ruby/rex-core dev-ruby/rex-socket dev-ruby/rex-text"
