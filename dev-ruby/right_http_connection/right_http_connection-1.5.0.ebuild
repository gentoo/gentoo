# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

RUBY_FAKEGEM_TASK_TEST="cucumber"

inherit ruby-fakegem

DESCRIPTION="RightScale's robust HTTP/S connection module"
HOMEPAGE="https://github.com/rightscale/right_http_connection"
SRC_URI="https://github.com/rightscale/right_http_connection/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

USE_RUBY="${USE_RUBY/ruby22/}" ruby_add_bdepend "test? (
	dev-util/cucumber
	dev-ruby/rspec:2
	dev-ruby/trollop:0
	dev-ruby/flexmock
)"

all_ruby_prepare() {
	rm Gemfile Gemfile.lock || die
	sed -i -e '/bundler/ s:^:#:' \
		-e 'arequire "rspec"' features/support/env.rb || die

	# Avoid features that require manual input (PEM pass phrase) or have
	# certificate issues due to unknown CA.
	rm -f features/{proxy_ssl,ssl}.feature || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby22)
			einfo "cucumber is not yet available for ruby22"
			;;
		*)
			${RUBY} -S cucumber --format progress features || die
			;;
	esac
}
