# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="A common interface to HMAC functionality as documented in RFC2104"
HOMEPAGE="http://ruby-hmac.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "
	test? ( >=dev-ruby/hoe-2.5.0 )"
