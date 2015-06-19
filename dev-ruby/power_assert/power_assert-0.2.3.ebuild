# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/power_assert/power_assert-0.2.3.ebuild,v 1.1 2015/03/03 18:16:40 mrueg Exp $

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Shows each value of variables and method calls in the expression"
HOMEPAGE="https://github.com/k-tsj/power_assert"
LICENSE="|| ( Ruby BSD-2 )"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"

SLOT="0"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile || die
}
