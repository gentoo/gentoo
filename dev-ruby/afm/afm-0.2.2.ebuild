# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/afm/afm-0.2.2.ebuild,v 1.8 2015/04/01 05:55:13 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A very simple library to read Adobe Font Metrics files"
HOMEPAGE="https://github.com/halfbyte/afm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/shoulda )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/s/^/#/" Rakefile test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/test_afm.rb || die
}
