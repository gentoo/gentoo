# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="Library for encoding QR Codes"
HOMEPAGE="https://whomwah.github.com/rqrcode/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/chunky_png"

all_ruby_prepare() {
	sed -i -e '/[bB]undler/s:^:#:' Rakefile || die
}
