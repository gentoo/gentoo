# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby Modelling and Generator Framework"
HOMEPAGE="https://github.com/mthiede/rgen"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="amd64 hppa ppc sparc x86"

each_ruby_test() {
	${RUBY} -S testrb $(find test -type f -name '*_test.rb') || die
}
