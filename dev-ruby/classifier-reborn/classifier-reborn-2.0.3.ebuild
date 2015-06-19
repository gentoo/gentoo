# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/classifier-reborn/classifier-reborn-2.0.3.ebuild,v 1.2 2015/01/05 15:51:03 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="Module to allow Bayesian and other types of classifications"
HOMEPAGE="https://github.com/jekyll/classifier-reborn"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gsl test"

ruby_add_rdepend ">=dev-ruby/fast-stemmer-1.0.0
	!!dev-ruby/classifier
	gsl? ( dev-ruby/rb-gsl )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	if use !gsl; then
		sed -e 's/$GSL = true/$GSL = false/'\
			-e 's/vector_serialize/vector/'\
			-i lib/${PN}/lsi.rb || die
	fi
}
