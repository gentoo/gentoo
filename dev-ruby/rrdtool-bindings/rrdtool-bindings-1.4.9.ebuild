# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-ng

MY_P=${P/-bindings}

DESCRIPTION="Ruby bindings for rrdtool"
HOMEPAGE="http://oss.oetiker.ch/rrdtool/"
SRC_URI="http://oss.oetiker.ch/rrdtool/pub/${MY_P}.tar.gz"
RUBY_S="$MY_P"/bindings/ruby

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="graph test"
REQUIRED_USE="test? ( graph )"

# Block on older versions of rrdtool that install the bindings themselves.
# requires rrd_xport which requires rrd_graph
RDEPEND="
	~net-analyzer/rrdtool-${PV}[graph=]
"
DEPEND="
	test? ( ~net-analyzer/rrdtool-${PV}[graph] )
"

RUBY_PATCHES=(
	"${FILESDIR}"/${PN}-1.4.8-graph-ruby.patch
)

each_ruby_configure() {
	${RUBY} extconf.rb \
		--with-cflags="${CFLAGS} $(usex graph -DHAVE_RRD_GRAPH '')" || die
}

each_ruby_compile() {
	emake V=1
}

each_ruby_test() {
	${RUBY} -I. test.rb || die
}

all_ruby_install() {
	dodoc CHANGES README
}

each_ruby_install() {
	DESTDIR=${D} emake install
}
