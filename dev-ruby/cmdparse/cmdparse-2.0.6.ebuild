# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/cmdparse/cmdparse-2.0.6.ebuild,v 1.8 2015/04/27 08:57:00 ago Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc/output/rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

IUSE=""

DESCRIPTION="Advanced command line parser supporting commands"
HOMEPAGE="http://cmdparse.gettalong.org/"

KEYWORDS="amd64 ppc64 x86"
LICENSE="LGPL-3"
SLOT="0"

each_ruby_test() {
	${RUBY} -Ilib net.rb stat || die "test failed"
}
