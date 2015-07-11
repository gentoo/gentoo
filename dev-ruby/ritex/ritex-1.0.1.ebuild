# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ritex/ritex-1.0.1.ebuild,v 1.2 2015/07/11 20:38:26 zlogene Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README ReleaseNotes"

inherit ruby-fakegem

DESCRIPTION="Converts expressions from WebTeX into MathML"
HOMEPAGE="http://masanjin.net/ritex/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/racc"
DEPEND+=" test? ( app-text/itex2mml )"

all_ruby_prepare() {
	# Fix tests
	sed -i -e "s#\./itex2MML#/usr/bin/itex2MML#;142d" test/mathml.rb || die
	sed -i -e "12d" test/answer-key.yaml || die
}

each_ruby_test() {
	${RUBY} -Ilib:. test/all.rb || die
}
