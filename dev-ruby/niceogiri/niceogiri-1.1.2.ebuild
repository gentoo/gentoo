# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/niceogiri/niceogiri-1.1.2.ebuild,v 1.8 2015/04/18 07:31:39 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC="doc"

inherit ruby-fakegem

DESCRIPTION="Some wrappers around and helpers for XML manipulation using Nokogiri"
HOMEPAGE="https://github.com/benlangfeld/Niceogiri"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend "dev-ruby/nokogiri"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	sed -i -e '/guard-rspec/d' ${PN}.gemspec || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
