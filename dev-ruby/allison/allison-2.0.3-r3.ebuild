# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README"
RUBY_FAKEGEM_EXTRAINSTALL="cache"

inherit ruby-fakegem

DESCRIPTION="A modern, pretty RDoc template"
HOMEPAGE="https://fauna.github.com/fauna/allison/files/README.html"

LICENSE="AFL-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-solaris"
IUSE=""

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r contrib
}
