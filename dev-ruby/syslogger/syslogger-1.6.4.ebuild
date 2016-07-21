# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

# if ever needed
#GITHUB_USER="crohr"
#GITHUB_PROJECT="${PN}"

inherit ruby-fakegem

DESCRIPTION="Drop-in replacement for the standard Logger, that logs to the syslog"
HOMEPAGE="https://github.com/crohr/syslogger"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	doc? ( >=dev-ruby/rdoc-2.4.2 )"

all_ruby_prepare() {
	sed -i '/[Bb]undler/d' Rakefile || die
}
