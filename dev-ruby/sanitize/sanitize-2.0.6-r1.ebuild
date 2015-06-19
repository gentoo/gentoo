# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sanitize/sanitize-2.0.6-r1.ebuild,v 1.2 2014/04/24 16:46:32 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Sanitize is a whitelist-based HTML sanitizer"
HOMEPAGE="https://github.com/rgrove/sanitize"
SRC_URI="https://github.com/rgrove/sanitize/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE="test"

ruby_add_rdepend "dev-ruby/nokogiri"
ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile || die "sed failed"
}
