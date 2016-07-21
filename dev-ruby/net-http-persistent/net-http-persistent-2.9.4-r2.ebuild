# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Manages persistent connections using Net::HTTP plus a speed fix for Ruby 1.8"
HOMEPAGE="https://github.com/drbrain/net-http-persistent"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc test"

ruby_add_bdepend "doc? ( dev-ruby/hoe )
	test? ( dev-ruby/hoe dev-ruby/minitest )"

all_ruby_prepare() {
	# due to hoe
	sed -i -e "/license/d" Rakefile || die
}
