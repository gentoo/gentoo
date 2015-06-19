# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/inifile/inifile-3.0.0.ebuild,v 1.2 2015/02/01 15:33:30 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md History.txt"

inherit ruby-fakegem

DESCRIPTION="Native Ruby package for reading and writing INI files"
HOMEPAGE="https://github.com/TwP/inifile"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

each_ruby_test() {
	${RUBY} -S testrb test/test_*.rb || die
}
