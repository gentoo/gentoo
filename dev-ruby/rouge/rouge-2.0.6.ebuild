# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Yet-another-markdown-parser using a strict syntax definition in pure Ruby"
HOMEPAGE="https://github.com/jneen/rouge"
#SRC_URI="https://github.com/jneen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="2"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/redcarpet )"
ruby_add_rdepend "dev-ruby/redcarpet
	!!dev-ruby/rouge:0"

RESTRICT="test"
# Depends on dev-ruby/wrong, which is not packaged yet.
