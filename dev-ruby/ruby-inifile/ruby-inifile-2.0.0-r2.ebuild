# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# ruby22 -> Incompatible code
USE_RUBY="ruby20 ruby21"

inherit ruby-ng

DESCRIPTION="Small library to parse INI-files in Ruby"
HOMEPAGE="http://raa.ruby-lang.org/project/ruby-inifile/"
SRC_URI="http://gregoire.lejeune.free.fr/${PN}_${PV}.tar.gz"

SLOT="0"
IUSE=""
LICENSE="Ruby"
KEYWORDS="~amd64 ~x86"
RUBY_S=${PN}

each_ruby_test() {
	cd tests
	for test in *.rb ; do
		${RUBY} -I../lib $test || die
	done
}

each_ruby_install() {
	${RUBY} setup.rb config --prefix="${D}"/usr || die
	${RUBY} setup.rb install || die
}

all_ruby_install() {
	dodoc AUTHORS README
}
