# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/fuubar/fuubar-2.0.0.ebuild,v 1.1 2014/12/31 08:19:46 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Instafailing RSpec progress bar formatter"
HOMEPAGE="https://github.com/jeffkreeftmeijer/fuubar"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/rspec:3 >=dev-ruby/ruby-progressbar-1.4"

each_ruby_test() {
	export CI=true
	each_fakegem_test
}
