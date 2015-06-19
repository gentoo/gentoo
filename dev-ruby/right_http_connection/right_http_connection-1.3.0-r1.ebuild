# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/right_http_connection/right_http_connection-1.3.0-r1.ebuild,v 1.1 2015/03/29 07:18:38 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

RUBY_FAKEGEM_TASK_TEST="cucumber"

inherit ruby-fakegem

DESCRIPTION="RightScale's robust HTTP/S connection module"
HOMEPAGE="http://rightscale.rubyforge.org/"
SRC_URI="https://github.com/rightscale/right_http_connection/tarball/v${PV} -> ${P}.tgz"
RUBY_S="rightscale-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RESTRICT="test"
#USE_RUBY="ruby19" ruby_add_bdepend "test? ( dev-util/cucumber )"

all_ruby_prepare() {
	rm Gemfile Gemfile.lock || die
	sed -i -e '/bundler/ s:^:#:' features/support/env.rb || die
}

each_ruby_test() {
	case ${RUBY} in
		*ruby19)
			;;
		*)
			${RUBY} -S cucumber features || die
			;;
	esac
}
