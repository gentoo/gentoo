# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="jruby"

RUBY_FAKEGEM_SUFFIX="java"

RUBY_FAKEGEM_EXTRAINSTALL="javalib"

inherit ruby-fakegem

DESCRIPTION="Customizable typed programming language with Ruby-inspired syntax"
HOMEPAGE="http://kenai.com/projects/duby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/bitescript"

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples || die
}
